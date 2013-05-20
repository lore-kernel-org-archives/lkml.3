Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756956Ab3ETOno (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 10:43:44 -0400
Received: from relay.parallels.com ([195.214.232.42]:34717 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756493Ab3ETOnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 10:43:43 -0400
Message-ID: <519A3693.8020006@parallels.com>
Date: Mon, 20 May 2013 18:43:31 +0400
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: <akpm@linux-foundation.org>, <jlayton@redhat.com>,
        <lucas.demarchi@profusion.mobi>, <rusty@rustcorp.com.au>,
        <linux-kernel@vger.kernel.org>, <bfields@fieldses.org>,
        <viro@zeniv.linux.org.uk>, <bharrosh@panasas.com>, <devel@openvz.org>
Subject: Re: [RFC PATCH] kmod: add ability to swap root in usermode helper
References: <20130520070017.7957.9224.stgit@localhost.localdomain> <20130520135716.GA10084@redhat.com>
In-Reply-To: <20130520135716.GA10084@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.18.163]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

20.05.2013 17:57, Oleg Nesterov пишет:
> On 05/20, Stanislav Kinsbursky wrote:
>>
>> Usermode helper executes all binaries in global "init" root context. This
>> doesn't allow to call to call the binary from other root (for example in a
>> container).
>> Currently, containerized NFS server requires an ability to execute a binary in
>> a other context, than "init" root (UMH is used for client recovery tracking).
>> This patch adds root swap to ____call_usermodehelper(), if non-NULL root was
>> passed as a part of subprocess_info data,
>
> Why do we need the new member/arguments?
>
>> @@ -215,6 +216,9 @@ static int ____call_usermodehelper(void *data)
>>   	 */
>>   	set_user_nice(current, 0);
>>
>> +	if (sub_info->root)
>> +		set_fs_root(current->fs, sub_info->root);
>
> Can't subprocess_info->init() do this? You can pass root as ->data.
>
> IOW, unless I missed something, nfs can do this without any changes
> in kmod.c.
>
> Oleg.
>

Thanks for the comment.
Yes, it definitely can. But, NFS server in the the only place. Usermode helper in
called from NFS client code and thus the same functionality is required there as well.
Moreover, set_fs_root() is not exported.
And adding an ability of a root swap to usermode helper looks quite logical. At least from the
"containers" point of view, which usually have it's own root.

-- 
Best regards,
Stanislav Kinsbursky
