Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942AbaLJA0I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 19:26:08 -0500
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:49170 "HELO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752495AbaLJA0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 19:26:06 -0500
MIME-Version: 1.0
In-Reply-To: <CALnjE+o4tbQVTyVkzdOG8zj=qxPZ8Dv3vGHbYkBmghxsLgKkkw@mail.gmail.com>
References: <1417575363-13770-1-git-send-email-joestringer@nicira.com>
 <1417575363-13770-2-git-send-email-joestringer@nicira.com> <CALnjE+o4tbQVTyVkzdOG8zj=qxPZ8Dv3vGHbYkBmghxsLgKkkw@mail.gmail.com>
From: Joe Stringer <joestringer@nicira.com>
Date: Tue, 9 Dec 2014 16:25:44 -0800
Message-ID: <CANr6G5yOqVkA6hf3J9mk41Kh=0k3sM3tQx4sdADSgFaAx9xrWg@mail.gmail.com>
Subject: Re: [PATCHv11 net-next 2/2] openvswitch: Add support for unique flow IDs.
To: Pravin Shelar <pshelar@nicira.com>
Cc: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "dev@openvswitch.org" <dev@openvswitch.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 December 2014 at 10:32, Pravin Shelar <pshelar@nicira.com> wrote:
> On Tue, Dec 2, 2014 at 6:56 PM, Joe Stringer <joestringer@nicira.com> wrote:
>> @@ -662,11 +664,18 @@ static void get_dp_stats(const struct datapath *dp, struct ovs_dp_stats *stats,
>>         }
>>  }
>>
>> -static size_t ovs_flow_cmd_msg_size(const struct sw_flow_actions *acts)
>> +static size_t ovs_flow_cmd_msg_size(const struct sw_flow_actions *acts,
>> +                                   const struct sw_flow_id *sfid)
>>  {
>> +       size_t sfid_len = 0;
>> +
>> +       if (sfid && sfid->ufid_len)
>> +               sfid_len = nla_total_size(sfid->ufid_len);
>> +
> Can you also use ufid_flags to determine exact msg size?

Yeah, that should be straightforward.


>> @@ -849,13 +876,30 @@ static int ovs_flow_cmd_new(struct sk_buff *skb, struct genl_info *info)
>>         }
>>
>>         /* Extract key. */
>> -       ovs_match_init(&match, &new_flow->unmasked_key, &mask);
>> +       ovs_match_init(&match, &key, &mask);
>>         error = ovs_nla_get_match(&match, a[OVS_FLOW_ATTR_KEY],
>>                                   a[OVS_FLOW_ATTR_MASK], log);
>>         if (error)
>>                 goto err_kfree_flow;
>>
>> -       ovs_flow_mask_key(&new_flow->key, &new_flow->unmasked_key, &mask);
>> +       ovs_flow_mask_key(&new_flow->key, &key, &mask);
>> +
>> +       /* Extract flow id. */
>> +       error = ovs_nla_copy_ufid(a[OVS_FLOW_ATTR_UFID], &new_flow->ufid, log);
>> +       if (error)
>> +               goto err_kfree_flow;
>
> Returning zero in case of no UFID is strange. Can you check for UFID
> attribute and then copy ufid unconditionally?

Right, along with the changes I'll make to integrating unmasked_key
and UFID this should collapse into a single call to
ovs_nla_copy_identifier() which will handle both cases.

>> @@ -877,8 +921,12 @@ static int ovs_flow_cmd_new(struct sk_buff *skb, struct genl_info *info)
>>                 error = -ENODEV;
>>                 goto err_unlock_ovs;
>>         }
>> +
>>         /* Check if this is a duplicate flow */
>> -       flow = ovs_flow_tbl_lookup(&dp->table, &new_flow->unmasked_key);
>> +       if (new_flow->ufid)
>> +               flow = ovs_flow_tbl_lookup_ufid(&dp->table, new_flow->ufid);
>> +       if (!flow)
>> +               flow = ovs_flow_tbl_lookup(&dp->table, &new_flow->key);
>
> Need tight checking, for example what if flow with UFID does not exist
> in UFID table but it exist in flow-table? This can complicate
> flow-update case where we can not assume UFID of new and old flow is
> same.

OK, I overlooked this for the UFID case. The non-UFID case does an
exact lookup later in the function, we could add a check in the UFID
case to compare the masked keys and return an error if they are
unequal.


>> @@ -980,45 +1032,34 @@ static int ovs_flow_cmd_set(struct sk_buff *skb, struct genl_info *info)
>>         struct nlattr **a = info->attrs;
>>         struct ovs_header *ovs_header = info->userhdr;
>>         struct sw_flow_key key;
>> -       struct sw_flow *flow;
>> +       struct sw_flow *flow = NULL;
>>         struct sw_flow_mask mask;
>>         struct sk_buff *reply = NULL;
>>         struct datapath *dp;
>>         struct sw_flow_actions *old_acts = NULL, *acts = NULL;
>>         struct sw_flow_match match;
>> +       struct sw_flow_id *ufid;
>> +       u32 ufid_flags = ovs_nla_get_ufid_flags(a[OVS_FLOW_ATTR_UFID_FLAGS]);
>>         int error;
>>         bool log = !a[OVS_FLOW_ATTR_PROBE];
>>
>> -       /* Extract key. */
>> -       error = -EINVAL;
>> -       if (!a[OVS_FLOW_ATTR_KEY]) {
>> +       /* Extract identifier. Take a copy to avoid "Wframe-larger-than=1024"
>> +        * warning.
>> +        */
> What if we limit the implementation of UFID to max 128 bit, does it
> still gives you the warning?

It will if we still use struct sw_flow_id, when we combine
UFID+unmasked key. Possibly not with just a 128bit array. I'll look
into it.

>> +       error = ovs_nla_copy_ufid(a[OVS_FLOW_ATTR_UFID], &ufid, log);
>> +       if (error)
>> +               return error;
>> +       if (a[OVS_FLOW_ATTR_KEY]) {
>> +               ovs_match_init(&match, &key, &mask);
>> +               error = ovs_nla_get_match(&match, a[OVS_FLOW_ATTR_KEY],
>> +                                         a[OVS_FLOW_ATTR_MASK], log);
>> +       } else if (!ufid) {
>>                 OVS_NLERR(log, "Flow key attribute not present in set flow.");
>> -               goto error;
>> +               error = -EINVAL;
>>         }
>> -
>> -       ovs_match_init(&match, &key, &mask);
>> -       error = ovs_nla_get_match(&match, a[OVS_FLOW_ATTR_KEY],
>> -                                 a[OVS_FLOW_ATTR_MASK], log);
>>         if (error)
>>                 goto error;
>>
>> -       /* Validate actions. */
>> -       if (a[OVS_FLOW_ATTR_ACTIONS]) {
>> -               acts = get_flow_actions(a[OVS_FLOW_ATTR_ACTIONS], &key, &mask,
>> -                                       log);
>> -               if (IS_ERR(acts)) {
>> -                       error = PTR_ERR(acts);
>> -                       goto error;
>> -               }
>> -
>> -               /* Can allocate before locking if have acts. */
>> -               reply = ovs_flow_cmd_alloc_info(acts, info, false);
>> -               if (IS_ERR(reply)) {
>> -                       error = PTR_ERR(reply);
>> -                       goto err_kfree_acts;
>> -               }
>> -       }
>> -
> Why are you moving this action validation under ovs-lock?

The thought was that flow_cmd_set may receive UFID and not key/mask.
One could imagine a command that sends a UFID and actions, telling OVS
kmod to update just the actions. Masked key is required for
ovs_nla_copy_actions(), so in this case a lookup would be required to
get a masked key.

Perhaps the better alternative for the moment is to still require flow
key and mask for this command (just as we do for flow_cmd_new). That
would simplify this change greatly, and doesn't affect current OVS
userspace.

>> @@ -1194,9 +1254,18 @@ unlock:
>>
>>  static int ovs_flow_cmd_dump(struct sk_buff *skb, struct netlink_callback *cb)
>>  {
>> +       struct nlattr *a[__OVS_FLOW_ATTR_MAX];
>>         struct ovs_header *ovs_header = genlmsg_data(nlmsg_data(cb->nlh));
>>         struct table_instance *ti;
>>         struct datapath *dp;
>> +       u32 ufid_flags;
>> +       int err;
>> +
>> +       err = nlmsg_parse(cb->nlh, GENL_HDRLEN + dp_flow_genl_family.hdrsize,
>> +                         a, dp_flow_genl_family.maxattr, flow_policy);
>
> Can you add genl helper function for this?

OK.

>> @@ -1235,6 +1304,8 @@ static const struct nla_policy flow_policy[OVS_FLOW_ATTR_MAX + 1] = {
>>         [OVS_FLOW_ATTR_ACTIONS] = { .type = NLA_NESTED },
>>         [OVS_FLOW_ATTR_CLEAR] = { .type = NLA_FLAG },
>>         [OVS_FLOW_ATTR_PROBE] = { .type = NLA_FLAG },
>> +       [OVS_FLOW_ATTR_UFID] = { .type = NLA_UNSPEC },
>> +       [OVS_FLOW_ATTR_UFID_FLAGS] = { .type = NLA_U32 },
>>  };
>>
>>  static const struct genl_ops dp_flow_genl_ops[] = {
>> diff --git a/net/openvswitch/flow.h b/net/openvswitch/flow.h
>> index a8b30f3..7f31dbf 100644
>> --- a/net/openvswitch/flow.h
>> +++ b/net/openvswitch/flow.h
>> @@ -197,6 +197,13 @@ struct sw_flow_match {
>>         struct sw_flow_mask *mask;
>>  };
>>
>> +#define MAX_UFID_LENGTH 256
>> +
> For now we can limit this to 128 bits.

Is there a reason beyond trying to avoid the warning in flow_cmd_set()?
I suppose that its purpose as an identifier means that it's unlikely to
need to be much bigger in future (indeed, the larger it gets, the more
it would trade off the performance gains from using it).

>> @@ -213,13 +220,16 @@ struct flow_stats {
>>
>>  struct sw_flow {
>>         struct rcu_head rcu;
>> -       struct hlist_node hash_node[2];
>> -       u32 hash;
>> +       struct {
>> +               struct hlist_node node[2];
>> +               u32 hash;
>> +       } flow_hash, ufid_hash;
> I am not sure about _hash suffix here, Can you explain it? I think
> _table is better.

Agreed, table is better.

>>         int stats_last_writer;          /* NUMA-node id of the last writer on
>>                                          * 'stats[0]'.
>>                                          */
>>         struct sw_flow_key key;
>> -       struct sw_flow_key unmasked_key;
>> +       struct sw_flow_id *ufid;
> Lets move this structure inside sw_flow, so that we can avoid one
> kmalloc during flow-install in case of UFID. something like:
>
> struct {
>     u32 ufid_len;
>     union {
>         u32 ufid[MAX_UFID_LENGTH / 4];
>         struct sw_flow_key *unmasked_key;
>     }
> } id;

Agreed.

>> @@ -424,10 +475,9 @@ static struct sw_flow *masked_flow_lookup(struct table_instance *ti,
>>         ovs_flow_mask_key(&masked_key, unmasked, mask);
>>         hash = flow_hash(&masked_key, key_start, key_end);
>>         head = find_bucket(ti, hash);
>> -       hlist_for_each_entry_rcu(flow, head, hash_node[ti->node_ver]) {
>> -               if (flow->mask == mask && flow->hash == hash &&
>> -                   flow_cmp_masked_key(flow, &masked_key,
>> -                                         key_start, key_end))
>> +       hlist_for_each_entry_rcu(flow, head, flow_hash.node[ti->node_ver]) {
>> +               if (flow->mask == mask && flow->flow_hash.hash == hash &&
>> +                   flow_cmp_masked_key(flow, &masked_key, key_start, key_end))
>>                         return flow;
>>         }
>>         return NULL;
>> @@ -469,7 +519,40 @@ struct sw_flow *ovs_flow_tbl_lookup_exact(struct flow_table *tbl,
>>         /* Always called under ovs-mutex. */
>>         list_for_each_entry(mask, &tbl->mask_list, list) {
>>                 flow = masked_flow_lookup(ti, match->key, mask);
>> -               if (flow && ovs_flow_cmp_unmasked_key(flow, match))  /* Found */
>> +               if (flow && !flow->ufid &&
> why not NULL check for flow->unmasked_key here rather than ufid?

In this version, I tried to consistently use flow->ufid as the switch
for whether UFID exists or not. In the next version, this statement
would refer to flow->id->ufid_len.

The current approach means that ovs_flow_tbl_lookup_exact() is really
ovs_flow_tbl_lookup_unmasked_key(). Do you think this should remain
specific to unmasked key or should it be made to check that the
identifier (ufid OR unmasked key) is the same?
