Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593Ab3BGJRI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 04:17:08 -0500
Received: from relay.parallels.com ([195.214.232.42]:58461 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600Ab3BGJRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 04:17:03 -0500
Message-ID: <511370D5.4030100@parallels.com>
Date: Thu, 7 Feb 2013 13:16:05 +0400
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tommi Rantala <tt.rantala@gmail.com>
CC: Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@parisplace.org>,
        <linux-security-module@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: selinux_msg_queue_msgrcv() oops
References: <CA+ydwtqgnMGuuHHWwj7jZh14WNdCFW_KA_APH-XZYX+RA-Ls1Q@mail.gmail.com> <5112662D.1010406@tycho.nsa.gov> <CA+ydwtpBNinVYa3zxoGVWjQLemxTyqTCm=o8mPut-F-DZx1xVg@mail.gmail.com> <511284B2.2070402@tycho.nsa.gov> <CA+ydwtp6fjMKsG4Oo5Ep2WXaykH+5D7MVWSHzUtnUFhr_HkJNw@mail.gmail.com>
In-Reply-To: <CA+ydwtp6fjMKsG4Oo5Ep2WXaykH+5D7MVWSHzUtnUFhr_HkJNw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.29.37]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

06.02.2013 23:51, Tommi Rantala пишет:
> 2013/2/6 Stephen Smalley <sds@tycho.nsa.gov>:
>> On 02/06/2013 10:21 AM, Tommi Rantala wrote:
>>>
>>> 2013/2/6 Stephen Smalley <sds@tycho.nsa.gov>:
>>>>
>>>> On 02/06/2013 07:56 AM, Tommi Rantala wrote:
>>>>>
>>>>>
>>>>> Hello,
>>>>>
>>>>> I'm hitting an oops in selinux_msg_queue_msgrcv() when fuzzing with
>>>>> Trinity as the root user (in a qemu VM):
>>>>
>>>>
>>>>
>>>> NULL msg->security at that point is a bug in the ipc subsystem; SELinux
>>>> is
>>>> just the messenger.  Normally msg->security is set for every allocated
>>>> msg
>>>> by load_msg() -> security_msg_msg_alloc() ->
>>>> selinux_msg_msg_alloc_security(), and freed/cleared upon free_msg() ->
>>>> security_msg_msg_free() -> selinux_msg_msg_free_security().  Looking
>>>> around,
>>>> I see copy_msg() introduced for checkpoint-restore initializes
>>>> dst->security
>>>> to NULL but never sets it properly?
>>>
>>>
>>> I am indeed building with CONFIG_CHECKPOINT_RESTORE=y, so your
>>> analysis seems to be correct.
>>
>>
>> (cc originator of the bug)
>>
>> If I am reading this correctly, then when the copy msg was created, a msg
>> security struct was already allocated
>> (prepare_copy->load_msg->security_msg_msg_alloc).  So having copy_msg()
>> clear dst->security is also a memory leak in addition to leading to this
>> oops.  Attached is a possible, un-tested fix.
>
> I can still reproduce the exact same oops with the patch applied. I
> also wanted to be sure that copy_msg() is called, so I added a warning
> there, but that never gets triggered. So I suppose the problem is not
> actually related to CONFIG_CHECKPOINT_RESTORE.
>

Hello.
Unfortunately, you are not the first one, who experience problems with Trinity running in KVM.

copy_msg() won't be called unless you'll specify the MSG_COPY flag in msgrcv() flags parameter.

Could you make a small investigation around the problem?
For example, does this problem appear, is you disable CONFIG_CHECKPOINT_RESTORE config option?


-- 
Best regards,
Stanislav Kinsbursky
