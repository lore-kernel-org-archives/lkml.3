Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077AbaKUTuZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 14:50:25 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:58390 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbaKUTuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 14:50:23 -0500
Message-ID: <546F977B.7040500@amacapital.net>
Date: Fri, 21 Nov 2014 11:50:19 -0800
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, arnd@arndb.de,
        ebiederm@xmission.com, gnomes@lxorguk.ukuu.org.uk, teg@jklm.no,
        jkosina@suse.cz, luto@amacapital.net, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: daniel@zonque.org, dh.herrmann@gmail.com, tixxdz@opendz.org
Subject: Re: kdbus: add code to gather metadata
References: <1416546149-24799-1-git-send-email-gregkh@linuxfoundation.org> <1416546149-24799-8-git-send-email-gregkh@linuxfoundation.org>
In-Reply-To: <1416546149-24799-8-git-send-email-gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2014 09:02 PM, Greg Kroah-Hartman wrote:
> From: Daniel Mack <daniel@zonque.org>
> 
> A connection chooses which metadata it wants to have attached to each
> message it receives with kdbus_cmd_hello.attach_flags. The metadata
> will be attached as items to the messages. All metadata refers to
> information about the sending task at sending time, unless otherwise
> stated. Also, the metadata is copied, not referenced, so even if the
> sending task doesn't exist anymore at the time the message is received,
> the information is still preserved.

Namespace comments below.

> +
> +static int kdbus_meta_append_cred(struct kdbus_meta *meta,
> +				  const struct kdbus_domain *domain)
> +{
> +	struct kdbus_creds creds = {
> +		.uid = from_kuid_munged(domain->user_namespace, current_uid()),
> +		.gid = from_kgid_munged(domain->user_namespace, current_gid()),
> +		.pid = task_pid_nr_ns(current, domain->pid_namespace),
> +		.tid = task_tgid_nr_ns(current, domain->pid_namespace),

This is better than before -- at least it gets translation right part of
the way.  But it's still wrong if the receiver's namespace doesn't match
the domain.

Also, please move pid and tgid into their own item.  They suck for
reasons that have been beaten to death.  Let's make it possible to
deprecate them separately in the future.

> +		.starttime = current->start_time,

I'm repeating myself here, but... why?

> +static int kdbus_meta_append_auxgroups(struct kdbus_meta *meta,
> +				       const struct kdbus_domain *domain)
> +{
> +	struct group_info *info;
> +	struct kdbus_item *item;
> +	int i, ret = 0;
> +	u64 *gid;
> +
> +	info = get_current_groups();
> +	item = kdbus_meta_append_item(meta, KDBUS_ITEM_AUXGROUPS,
> +				      info->ngroups * sizeof(*gid));
> +	if (IS_ERR(item)) {
> +		ret = PTR_ERR(item);
> +		goto exit_put_groups;
> +	}
> +
> +	gid = (u64 *) item->data;
> +
> +	for (i = 0; i < info->ngroups; i++)
> +		gid[i] = from_kgid_munged(domain->user_namespace,
> +					  GROUP_AT(info, i));

Ditto.

> +static int kdbus_meta_append_exe(struct kdbus_meta *meta)

NAK.

> +{
> +	struct mm_struct *mm = get_task_mm(current);
> +	struct path *exe_path = NULL;
> +	char *pathname;
> +	int ret = 0;
> +	size_t len;
> +	char *tmp;
> +
> +	if (!mm)
> +		return -EFAULT;
> +
> +	down_read(&mm->mmap_sem);
> +	if (mm->exe_file) {
> +		path_get(&mm->exe_file->f_path);
> +		exe_path = &mm->exe_file->f_path;
> +	}
> +	up_read(&mm->mmap_sem);
> +
> +	if (!exe_path)
> +		goto exit_mmput;
> +
> +	tmp = (char *)__get_free_page(GFP_TEMPORARY | __GFP_ZERO);
> +	if (!tmp) {
> +		ret = -ENOMEM;
> +		goto exit_path_put;
> +	}
> +
> +	pathname = d_path(exe_path, tmp, PAGE_SIZE);

My NAK notwithstanding, the namespacing here is completely bogus.

> +static int kdbus_meta_append_cmdline(struct kdbus_meta *meta)

NAK

> +static int kdbus_meta_append_caps(struct kdbus_meta *meta)
> +{
> +	struct caps {
> +		u32 last_cap;
> +		struct {
> +			u32 caps[_KERNEL_CAPABILITY_U32S];
> +		} set[4];
> +	} caps;
> +	unsigned int i;
> +	const struct cred *cred = current_cred();
> +
> +	caps.last_cap = CAP_LAST_CAP;
> +
> +	for (i = 0; i < _KERNEL_CAPABILITY_U32S; i++) {
> +		caps.set[0].caps[i] = cred->cap_inheritable.cap[i];
> +		caps.set[1].caps[i] = cred->cap_permitted.cap[i];
> +		caps.set[2].caps[i] = cred->cap_effective.cap[i];
> +		caps.set[3].caps[i] = cred->cap_bset.cap[i];
> +	}

Please leave this in so that I can root every single kdbus-using system.
 It'll be lots of fun.

Snark aside, the correct fix is IMO to delete this function entirely.
Even if you could find a way to implement it safely (which will be
distinctly nontrivial), it seems like a bad idea to begin with.

> +#ifdef CONFIG_CGROUPS
> +static int kdbus_meta_append_cgroup(struct kdbus_meta *meta)
> +{
> +	char *buf, *path;
> +	int ret;
> +
> +	buf = (char *)__get_free_page(GFP_TEMPORARY | __GFP_ZERO);
> +	if (!buf)
> +		return -ENOMEM;
> +
> +	path = task_cgroup_path(current, buf, PAGE_SIZE);

This may have strange interactions with cgroupns.  It's fixable, though,
but only once you implement translation at receive time, and I think
you'll have to do that to get any of this to work right.

> +
> +	if (path)
> +		ret = kdbus_meta_append_str(meta, KDBUS_ITEM_CGROUP, path);
> +	else
> +		ret = -ENAMETOOLONG;
> +
> +	free_page((unsigned long) buf);
> +
> +	return ret;
> +}
> +#endif
> +
> +#ifdef CONFIG_AUDITSYSCALL
> +static int kdbus_meta_append_audit(struct kdbus_meta *meta,
> +				   const struct kdbus_domain *domain)
> +{
> +	struct kdbus_audit audit;
> +
> +	audit.loginuid = from_kuid_munged(domain->user_namespace,
> +					  audit_get_loginuid(current));
> +	audit.sessionid = audit_get_sessionid(current);
> +
> +	return kdbus_meta_append_data(meta, KDBUS_ITEM_AUDIT,
> +				      &audit, sizeof(audit));

So *that's* what audit means.  Please document this and consider
renaming it to something like AUDIT_LOGINUID_AND_SESSIONID.

> +#ifdef CONFIG_SECURITY
> +static int kdbus_meta_append_seclabel(struct kdbus_meta *meta)
> +{
> +	u32 len, sid;
> +	char *label;
> +	int ret;
> +
> +	security_task_getsecid(current, &sid);
> +	ret = security_secid_to_secctx(sid, &label, &len);
> +	if (ret == -EOPNOTSUPP)
> +		return 0;
> +	if (ret < 0)
> +		return ret;
> +
> +	if (label && len > 0)
> +		ret = kdbus_meta_append_data(meta, KDBUS_ITEM_SECLABEL,
> +					     label, len);

This thing needs a clear, valid use case.  I think that the use case
should document how non-enforcing mode is supposed to work, too.

Also, there should be a justification for why the LSM hooks by
themselves aren't good enough to remove the need for this.

> +
> +/**
> + * kdbus_meta_size() - calculate the size of an excerpt of a metadata db
> + * @meta:	The database object containing the metadata

What is a "database object containing the metadata"?

Anyway, this is unreviewable because not only is the context in which
this function called not specified in this patch, but the function has
no callers in this patch.  However...

> + * @conn_dst:	The connection that is about to receive the data

...this suggests that this is called in the recipient's context, so...

> + * @mask:	Pointer to KDBUS_ATTACH_* bitmask to calculate the size for.
> + *		Callers *must* use the same mask for calls to
> + *		kdbus_meta_write().
> + *
> + * Return: the size in bytes the masked data will consume. Data that should
> + * not received by @conn_dst will be filtered out.
> + */
> +size_t kdbus_meta_size(const struct kdbus_meta *meta,
> +		       const struct kdbus_conn *conn_dst,
> +		       u64 *mask)
> +{
> +	struct kdbus_domain *domain = conn_dst->ep->bus->domain;
> +	const struct kdbus_item *item;
> +	size_t size = 0;
> +
> +	/*
> +	 * We currently don't have a way to translate capability flags between
> +	 * user namespaces, so let's drop these items in such cases.
> +	 */
> +	if (domain->user_namespace != current_user_ns())
> +		*mask &= ~KDBUS_ATTACH_CAPS;

...this is still completely wrong, and I'll be able to root kdbus systems :)

> +
> +	/*
> +	 * If the domain was created with hide_pid enabled, drop all items
> +	 * except for such not revealing anything about the task.
> +	 */
> +	if (domain->pid_namespace->hide_pid)
> +		*mask &= KDBUS_ATTACH_TIMESTAMP | KDBUS_ATTACH_NAMES |
> +			 KDBUS_ATTACH_CONN_DESCRIPTION;

Huh?  This looks wrong.

I realize that some of the systemd people seem to think that hide_pid is
unusable right now, but it really does seem to be usable.  Doing this,
however, will indeed make it unusable.

What are you trying to do here?  I think that the correct fix is to
remove support for all of the questionable metadata items and get rid of
this check.

--Andy
