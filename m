Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268Ab3ETPNk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 11:13:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24130 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755400Ab3ETPNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 11:13:39 -0400
Date: Mon, 20 May 2013 17:10:01 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: akpm@linux-foundation.org, jlayton@redhat.com,
        lucas.demarchi@profusion.mobi, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org, bfields@fieldses.org,
        viro@zeniv.linux.org.uk, bharrosh@panasas.com, devel@openvz.org
Subject: Re: [RFC PATCH] kmod: add ability to swap root in usermode helper
Message-ID: <20130520151001.GA13173@redhat.com>
References: <20130520070017.7957.9224.stgit@localhost.localdomain> <20130520135716.GA10084@redhat.com> <519A3693.8020006@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <519A3693.8020006@parallels.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20, Stanislav Kinsbursky wrote:
>
> 20.05.2013 17:57, Oleg Nesterov пишет:
>>
>> Why do we need the new member/arguments?
>>
>>> @@ -215,6 +216,9 @@ static int ____call_usermodehelper(void *data)
>>>   	 */
>>>   	set_user_nice(current, 0);
>>>
>>> +	if (sub_info->root)
>>> +		set_fs_root(current->fs, sub_info->root);
>>
>> Can't subprocess_info->init() do this? You can pass root as ->data.
>>
>> IOW, unless I missed something, nfs can do this without any changes
>> in kmod.c.
>>
>> Oleg.
>>
>
> Thanks for the comment.
> Yes, it definitely can. But, NFS server in the the only place. Usermode helper in
> called from NFS client code and thus the same functionality is required there as well.

Not sure I understand... OK, and why NFS client can't use the same
functionality?

> Moreover, set_fs_root() is not exported.

Then it should be exported, I think ;)

Or you can export the new helper.

> And adding an ability of a root swap to usermode helper looks quite logical. At least from the
> "containers" point of view, which usually have it's own root.

But it is not logical to uglify the code, imho.

OK, why nfs can't simply use this code

	static int umh_set_fs_root(struct subprocess_info *info, struct cred *new)
	{
		set_fs_root(current->fs, sub_info->data);
		return 0;
	}

	int call_usermodehelper_root(char *path, char **argv, char **envp, int wait,
				     struct path *root)
	{

		struct subprocess_info *info;

		info = call_usermodehelper_setup(path, argv, envp, gfp_mask,
							umh_set_fs_root, NULL, root);
		if (info == NULL)
			return -ENOMEM;
		return call_usermodehelper_exec(info, wait);
	}

? Why do you want to add the new member, the new arguments, the new helpers?

Oleg.

