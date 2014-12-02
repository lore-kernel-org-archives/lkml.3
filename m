Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933377AbaLBV2f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 16:28:35 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:60608 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932894AbaLBV2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 16:28:32 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
        Linux API <linux-api@vger.kernel.org>,
        linux-man <linux-man@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Richard Weinberger <richard@nod.at>,
        Kenton Varda <kenton@sandstorm.io>, stable <stable@vger.kernel.org>
References: <52e0643bd47b1e5c65921d6e00aea1f724bb510a.1417281801.git.luto@amacapital.net>
	<87h9xez20g.fsf@x220.int.ebiederm.org>
	<CALCETrXOz4C7Tu8mggBtR=k47ZmkuAhinVUxWJSFyS1Ep0HvRw@mail.gmail.com>
	<87mw75ygwp.fsf@x220.int.ebiederm.org>
	<CALCETrVfO4sBdZcQiZXsofPZMj7pqKeVbX+4g3dAj6WjUca+1w@mail.gmail.com>
	<87fvcxyf28.fsf_-_@x220.int.ebiederm.org>
	<CALCETrXsQbCeQBUo_FrXNVS42mBEFXz1jku9TicVbFhxTmNGmA@mail.gmail.com>
Date: Tue, 02 Dec 2014 15:26:20 -0600
In-Reply-To: <CALCETrXsQbCeQBUo_FrXNVS42mBEFXz1jku9TicVbFhxTmNGmA@mail.gmail.com>
	(Andy Lutomirski's message of "Tue, 2 Dec 2014 12:58:07 -0800")
Message-ID: <87bnnlvj43.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/KMw42mjKlt4i/aNqJ65NJ5EKVU+bgP8E=
X-SA-Exim-Connect-IP: 97.121.92.161
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.7 XMSubLong Long Subject
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ****;Andy Lutomirski <luto@amacapital.net>
X-Spam-Relay-Country: 
X-Spam-Timing: total 468 ms - load_scoreonly_sql: 0.07 (0.0%),
	signal_user_changed: 9 (1.9%), b_tie_ro: 7 (1.6%), parse: 1.51 (0.3%),
	extract_message_metadata: 18 (3.8%), get_uri_detail_list: 6 (1.2%),
	tests_pri_-1000: 7 (1.5%), tests_pri_-950: 1.08 (0.2%), tests_pri_-900: 0.88
	(0.2%), tests_pri_-400: 34 (7.2%), check_bayes: 33 (7.0%), b_tokenize: 12
	(2.5%), b_tok_get_all: 12 (2.6%), b_comp_prob: 3.0 (0.6%), b_tok_touch_all:
	3.4 (0.7%), b_finish: 0.64 (0.1%), tests_pri_0: 390 (83.3%), tests_pri_500:
	3.8 (0.8%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [CFT][PATCH 1/3] userns: Avoid problems with negative groups
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> writes:

> On Tue, Dec 2, 2014 at 12:25 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>>
>> Classic unix permission checks have an interesting feature, the group
>> permissions for a file can be set to less than the other permissions
>> on a file.  Occassionally this is used deliberately to give a certain
>> group of users fewer permissions than the default.
>>
>> Overlooking negative groups has resulted in the permission checks for
>> setting up a group mapping in a user namespace to be too lax.  Tighten
>> the permission checks in new_idmap_permitted to ensure that mapping
>> uids and gids into user namespaces without privilege will not result
>> in new combinations of credentials being available to the users.
>>
>> When setting mappings without privilege only the creator of the user
>> namespace is interesting as all other users that have CAP_SETUID over
>> the user namespace will also have CAP_SETUID over the user namespaces
>> parent.  So the scope of the unprivileged check is reduced to just
>> the case where cred->euid is the namespace creator.
>>
>> For setting a uid mapping without privilege only euid is considered as
>> setresuid can set uid, suid and fsuid from euid without privielege
>> making any combination of uids possible with user namespaces already
>> possible without them.
>>
>> For now seeting a gid mapping without privilege is removed.  The only
>> possible set of credentials that would be safe without a gid mapping
>> (egid without any supplementary groups) just doesn't happen in practice
>> so would simply lead to unused untested code.
>>
>> setgroups is modified to fail not only when the group ids do not
>> map but also when there are no gid mappings at all, preventing
>> setgroups(0, NULL) from succeeding when gid mappings have not been
>> established.
>>
>> For a small class of applications this change breaks userspace
>> and removes useful functionality.  This small class of applications
>> includes tools/testing/selftests/mount/unprivileged-remount-test.c
>>
>> Most of the removed functionality will be added back with the
>> addition of a one way knob to disable setgroups.  Once setgroups
>> is disabled setting the gid_map becomes as safe as setting the uid_map.
>>
>> For more common applications that set the uid_map and the gid_map with
>> privilege this change will have no effect on them.
>>
>> This should fix CVE-2014-8989.
>>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>> ---
>
>>
>> +static inline bool gid_mapping_possible(const struct user_namespace *ns)
>> +{
>> +       return ns->gid_map.nr_extents != 0;
>> +}
>> +
>
> Can you rename this to userns_may_setgroups or something like that?
> To me, gid_mapping_possible sounds like you're allowed to map gids,
> which sounds like the opposite condition, and it doesn't explain what
> the point is.

gid_mapping_established?

What I mean to be testing if is if from_kgid and make_kgid will work
because the gid mappings have been set.

The userns knob for setgroups is a different test and is added
in the next patch.  And yes we really need both or the knob can
start out as on, and we need to provent setgroups(0, NULL)
before the user namespace is unshared.

Although come to think about it probably makes sense to roll those two
test into one function and call that inline function from the setgroups
implementation.

Anyway I will think about it and see what I can do to make it easily
comprehensible.

>> diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
>> index aa312b0dc3ec..51d65b444951 100644
>> --- a/kernel/user_namespace.c
>> +++ b/kernel/user_namespace.c
>> @@ -812,16 +812,19 @@ static bool new_idmap_permitted(const struct file *file,
>>                                 struct user_namespace *ns, int cap_setid,
>>                                 struct uid_gid_map *new_map)
>>  {
>> -       /* Allow mapping to your own filesystem ids */
>> -       if ((new_map->nr_extents == 1) && (new_map->extent[0].count == 1)) {
>> +       const struct cred *cred = file->f_cred;
>> +
>> +       /* Allow a mapping without capabilities when allowing the root
>> +        * of the user namespace capabilities restricted to that id
>> +        * will not change the set of credentials available to that
>> +        * user.
>> +        */
>> +       if ((new_map->nr_extents == 1) && (new_map->extent[0].count == 1) &&
>> +           uid_eq(ns->owner, cred->euid)) {
>
> What's uid_eq(ns->owner, cred->euid)) for?  This should already be covered by:

This means that the only user we attempt to set up unprivileged mappings
for is the owner of the user namespace.  Anyone else should already
have capabilities in the parent user namespace or shouldn't be able to
set the mapping at all.

In practice it is a clarification to make it easier to think about the code.

>     if (cap_valid(cap_setid) && !file_ns_capable(file, ns, CAP_SYS_ADMIN))
>         goto out;
>
> (except that I don't know why cap_valid(cap_setid) is checked -- this
> ought to be enforced for projid_map, too, right?)

What to do with projid_map is entirely different discussion.  In
practice it is dead, and either XFS needs to be fixed to use it
or that code needs to be removed.  At the time I wrote it XFS
did not require any privileges to set project ids.

>>                 u32 id = new_map->extent[0].lower_first;
>>                 if (cap_setid == CAP_SETUID) {
>>                         kuid_t uid = make_kuid(ns->parent, id);
>> -                       if (uid_eq(uid, file->f_cred->fsuid))
>> -                               return true;
>> -               } else if (cap_setid == CAP_SETGID) {
>> -                       kgid_t gid = make_kgid(ns->parent, id);
>> -                       if (gid_eq(gid, file->f_cred->fsgid))
>> +                       if (uid_eq(uid, cred->euid))
>
> Why'd you change this from fsuid to euid?

Because strangely enough I can set euid to any other uid with
setresuid, but the same does not hold with fsuid.

So strictly speaking fsuid was actually wrong before.  In practice
fsuid == euid so I don't think anyone will care.  But I want very much
to enforce the rule that user namespaces can't give you any credentials
you couldn't get otherwise.

Eric
