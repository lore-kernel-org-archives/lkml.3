Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932205Ab3CDSgP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 13:36:15 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:47557 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932160Ab3CDSgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 13:36:13 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Vasily Kulikov <segoon@openwall.com>
Cc: Kees Cook <keescook@google.com>, Brad Spengler <spender@grsecurity.net>,
        Linux Containers <containers@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, PaX Team <pageexec@freemail.hu>,
        Dave Jones <davej@redhat.com>, kernel-hardening@lists.openwall.com
References: <CAGXu5jK7x+gFKgCN5=ZF+kSc4xSNbGtSERHCoOnCEgiJ1_wNGg@mail.gmail.com>
	<20130303005700.GA32213@austin.hallyn.com>
	<874ngtxgt5.fsf@xmission.com>
	<CAGXu5j+bwUx6r++ttvYg4yJrUUHxoQ86tQ0JzEBoQQU6KAh9ww@mail.gmail.com>
	<874ngsrvrh.fsf@xmission.com>
	<CAGXu5jJiO=BmjVbpVJhxHbafn5T_SQbe5g-RLxRbmknNnQMyfQ@mail.gmail.com>
	<87k3pnmwpk.fsf_-_@xmission.com> <878v63mwm3.fsf_-_@xmission.com>
	<20130304173611.GA8500@cachalot>
Date: Mon, 04 Mar 2013 10:36:01 -0800
In-Reply-To: <20130304173611.GA8500@cachalot> (Vasily Kulikov's message of
	"Mon, 4 Mar 2013 21:36:11 +0400")
Message-ID: <87y5e3dnce.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19+rBxsjJnENIfwYsuv0+SVTTQRjZle1pY=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0003]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Vasily Kulikov <segoon@openwall.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 2/2] fs: Limit sys_mount to only request filesystem modules.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vasily Kulikov <segoon@openwall.com> writes:

> (cc'ed kernel-hardening)
>
> On Sun, Mar 03, 2013 at 23:51 -0800, Eric W. Biederman wrote:
>> Modify the request_module to prefix the file system type with "fs-"
>> and add aliases to all of the filesystems that can be built as modules
>> to match.
>> 
>> A common practice is to build all of the kernel code and leave code
>> that is not commonly needed as modules, with the result that many
>> users are exposed to any bug anywhere in the kernel.
>> 
>> Looking for filesystems with a fs- prefix limits the pool of possible
>> modules that can be loaded by mount to just filesystems trivially
>> making things safer with no real cost.
>> 
>> Using aliases means user space can control the policy of which
>> filesystem modules are auto-loaded by editing /etc/modprobe.d/*.conf
>> with blacklist and alias directives.  Allowing simple, safe,
>> well understood work-arounds to known problematic software.
>> 
>> This also addresses a rare but unfortunate problem where the filesystem
>> name is not the same as it's module name and module auto-loading
>> would not work.  While writing this patch I saw a handful of such
>> cases.  The most significant being autofs that lives in the module
>> autofs4.
>> 
>> This is relevant to user namespaces because we can reach the request
>> module in get_fs_type() without having any special permissions, and
>> people get uncomfortable when a user specified string (in this case
>> the filesystem type) goes all of the way to request_module.
>> 
>> After having looked at this issue I don't think there is any
>> particular reason to perform any filtering or permission checks beyond
>> making it clear in the module request that we want a filesystem
>> module.  The common pattern in the kernel is to call request_module()
>> without regards to the users permissions.  In general all a filesystem
>> module does once loaded is call register_filesystem() and go to sleep.
>> Which means there is not much attack surface exposed by loading a
>> filesytem module unless the filesystem is mounted.  In a user
>> namespace filesystems are not mounted unless .fs_flags = FS_USERNS_MOUNT,
>> which most filesystems do not set today.
>> 
>> Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
>> Acked-by: Kees Cook <keescook@chromium.org>
>> Reported-by: Kees Cook <keescook@google.com>
>> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ...
>> diff --git a/fs/filesystems.c b/fs/filesystems.c
>> index da165f6..92567d9 100644
>> --- a/fs/filesystems.c
>> +++ b/fs/filesystems.c
>> @@ -273,7 +273,7 @@ struct file_system_type *get_fs_type(const char *name)
>>  	int len = dot ? dot - name : strlen(name);
>>  
>>  	fs = __get_fs_type(name, len);
>> -	if (!fs && (request_module("%.*s", len, name) == 0))
>> +	if (!fs && (request_module("fs-%.*s", len, name) == 0))
>>  		fs = __get_fs_type(name, len);
>>  
>>  	if (dot && fs && !(fs->fs_flags & FS_HAS_SUBTYPE)) {
>
> Maybe we should divide request_module() into several functions regarding
> expected caller's privileges?
>
> - request_module() for CAP_SYS_MODULE in init_ns
> - request_module_relaxed() for everybody
>
> request_module_relaxed() is used in get_fs_type(), dev_load() and all
> places where the safety of module loading is manually checked.  All old
> not yet checked users of request_module() will not be triggerable from user_ns.
> That's the same scheme as with capable() and ns_capable().

User namespaces in this discussion are pretty much a red-herring.  You
can already reach most request_module callers without having any
capabilities.  And honestly that seems fine.

It never ever hurts to request a module.

It only sometimes when something else has already gone wrong hurts to
get the module.

It makes sense to add a prefix when sending the module request to make
it clear what kind of module we are looking for.  That makes it easy to
tell why we are requesting the module and makes it easy to implement
policy controls in userspace.

I don't see any reason to limit request_module to people with some
capability or other.  The filesystem module_request just happened to be
after a capable(CAP_SYS_AMDIN) in this case which is the case people
noticed was a little fishy.

But if I have overlooked something I am happy to hear it.

Eric
