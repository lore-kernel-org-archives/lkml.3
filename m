Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077AbaLANu6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 08:50:58 -0500
Received: from svenfoo.org ([82.94.215.22]:46640 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753365AbaLANu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 08:50:56 -0500
Message-ID: <547C723C.6020305@zonque.org>
Date: Mon, 01 Dec 2014 14:50:52 +0100
From: Daniel Mack <daniel@zonque.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, arnd@arndb.de,
        ebiederm@xmission.com, gnomes@lxorguk.ukuu.org.uk, teg@jklm.no,
        jkosina@suse.cz, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: dh.herrmann@gmail.com, tixxdz@opendz.org
Subject: Re: kdbus: add code to gather metadata
References: <1416546149-24799-1-git-send-email-gregkh@linuxfoundation.org> <1416546149-24799-8-git-send-email-gregkh@linuxfoundation.org> <546F977B.7040500@amacapital.net>
In-Reply-To: <546F977B.7040500@amacapital.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

Sorry for the late response.

On 11/21/2014 08:50 PM, Andy Lutomirski wrote:
>> +static int kdbus_meta_append_cred(struct kdbus_meta *meta,
>> +				  const struct kdbus_domain *domain)
>> +{
>> +	struct kdbus_creds creds = {
>> +		.uid = from_kuid_munged(domain->user_namespace, current_uid()),
>> +		.gid = from_kgid_munged(domain->user_namespace, current_gid()),
>> +		.pid = task_pid_nr_ns(current, domain->pid_namespace),
>> +		.tid = task_tgid_nr_ns(current, domain->pid_namespace),
> 
> This is better than before -- at least it gets translation right part of
> the way.  But it's still wrong if the receiver's namespace doesn't match
> the domain.

Alright. The code now translates the items into each receiver's
namespaces individually, so we can also take possible chroot()
environments into account to do path translations.

> Also, please move pid and tgid into their own item.  They suck for
> reasons that have been beaten to death.  Let's make it possible to
> deprecate them separately in the future.

Ok, done now. As mentioned in the highpid thread, we can easily add
another item once we have a better source of information.

>> +static int kdbus_meta_append_caps(struct kdbus_meta *meta)
>> +{
>> +	struct caps {
>> +		u32 last_cap;
>> +		struct {
>> +			u32 caps[_KERNEL_CAPABILITY_U32S];
>> +		} set[4];
>> +	} caps;
>> +	unsigned int i;
>> +	const struct cred *cred = current_cred();
>> +
>> +	caps.last_cap = CAP_LAST_CAP;
>> +
>> +	for (i = 0; i < _KERNEL_CAPABILITY_U32S; i++) {
>> +		caps.set[0].caps[i] = cred->cap_inheritable.cap[i];
>> +		caps.set[1].caps[i] = cred->cap_permitted.cap[i];
>> +		caps.set[2].caps[i] = cred->cap_effective.cap[i];
>> +		caps.set[3].caps[i] = cred->cap_bset.cap[i];
>> +	}
> 
> Please leave this in so that I can root every single kdbus-using system.
>  It'll be lots of fun.
> 
> Snark aside, the correct fix is IMO to delete this function entirely.
> Even if you could find a way to implement it safely (which will be
> distinctly nontrivial), it seems like a bad idea to begin with.

Yes, we currently have no way of translating caps from one user
namespace to another, which means we cannot allow such an item to cross
user namespaces. We can add this functionality later once we have the
neccessary APIs.

>> +#ifdef CONFIG_CGROUPS
>> +static int kdbus_meta_append_cgroup(struct kdbus_meta *meta)
>> +{
>> +	char *buf, *path;
>> +	int ret;
>> +
>> +	buf = (char *)__get_free_page(GFP_TEMPORARY | __GFP_ZERO);
>> +	if (!buf)
>> +		return -ENOMEM;
>> +
>> +	path = task_cgroup_path(current, buf, PAGE_SIZE);
> 
> This may have strange interactions with cgroupns.  It's fixable, though,
> but only once you implement translation at receive time, and I think
> you'll have to do that to get any of this to work right.

Yes, agreed. We'll add translation to this item once cgroup namespaces
are in place. Until then, we'll expose the same information as other
parts of the Linux API already do.

>> +#ifdef CONFIG_AUDITSYSCALL
>> +static int kdbus_meta_append_audit(struct kdbus_meta *meta,
>> +				   const struct kdbus_domain *domain)
>> +{
>> +	struct kdbus_audit audit;
>> +
>> +	audit.loginuid = from_kuid_munged(domain->user_namespace,
>> +					  audit_get_loginuid(current));
>> +	audit.sessionid = audit_get_sessionid(current);
>> +
>> +	return kdbus_meta_append_data(meta, KDBUS_ITEM_AUDIT,
>> +				      &audit, sizeof(audit));
> 
> So *that's* what audit means.  Please document this and consider
> renaming it to something like AUDIT_LOGINUID_AND_SESSIONID.

The documentation was indeed bogus and is fixed now, along with man
other details. Thanks for spotting this!

>> +#ifdef CONFIG_SECURITY
>> +static int kdbus_meta_append_seclabel(struct kdbus_meta *meta)
>> +{
>> +	u32 len, sid;
>> +	char *label;
>> +	int ret;
>> +
>> +	security_task_getsecid(current, &sid);
>> +	ret = security_secid_to_secctx(sid, &label, &len);
>> +	if (ret == -EOPNOTSUPP)
>> +		return 0;
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	if (label && len > 0)
>> +		ret = kdbus_meta_append_data(meta, KDBUS_ITEM_SECLABEL,
>> +					     label, len);
> 
> This thing needs a clear, valid use case.  I think that the use case
> should document how non-enforcing mode is supposed to work, too.

kdbus just passes the seclabel along, if people want to use this for
security checks, then they need to call into libselinux, and should do
that by taking the enforcing mode into consideration. This is already
done in a lot of software that way.

> Also, there should be a justification for why the LSM hooks by
> themselves aren't good enough to remove the need for this.

SELinux and other MACs might want to do additional per-service security
checks. For example, a service manager might want to check the security
label of a service file against the security label of the client process
using the SELinux database before allow access. For this, we need to be
able to pass the client's security label race-free to libselinux so that
it can make its decision.

I've added the above to the documentation now.



Thanks for your review again - much appreciated!

Daniel



