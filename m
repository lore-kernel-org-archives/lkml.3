Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933527AbaHHVKa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:10:30 -0400
Received: from smtp102.biz.mail.bf1.yahoo.com ([98.139.221.61]:32094 "EHLO
	smtp102.biz.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933146AbaHHVKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 17:10:24 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: fS9BMbYVM1k3tak4MSFVp6fnSTXYiHQr4TdbQtX16l4rvhN
 yFFvunzdlDx0OlLHL1inNoBU303utNy5HWelwYU_xd6CSYRm.wUmwaiUJyef
 OoSqE1KWIzFTBbtk.kg4AzfkujCjwmeXaHzpEBNxoY0WtLd.02xUqm85KMTQ
 lWRfBjrGydIRWXIzu4PUk1wD4ULDWJ_MUwM2i.ly_GgdN88I_dMnolqnZ4As
 wdvfQ9G4P44CY6Req.xJ8Lhs3HCpwt40dUtG1Jda_B67srf3QlVHTqGobCTB
 2cXLn9hQjhOYZ9Mo.CbHGoNzdAiAPbspe23jIVeIT.J48F69qMQK1Tc2Mo6Y
 n618jxJHrrpCKZaY48mAmGP1HCUzsCE9NHdP9r5F2TBBA6txrhiD7utw6Cap
 fauVFqI4G.7m.iUWSrul_Vi6TznNmSRr9gR9E74lIVIHaBKRSstDOLLOm1cM
 1FAVL4KAky8kSfB5khwSh.T3ZY0tS0pVsLwKe0wmB5jwBk2iUpowIfTueeZN
 hF3U4NHrt19m1f6IUVbzHTN5hVtNq4FzQIplAlhCcae4KBxGknpYjYte3Jan
 nK7fQ.7psHsH5l5rk24M5t.vj.Ij74g--
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <53E53CC0.4090301@schaufler-ca.com>
Date: Fri, 08 Aug 2014 14:10:24 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Serge E. Hallyn" <serge@hallyn.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>
CC: Konstantin Khlebnikov <k.khlebnikov@samsung.com>,
        linux-security-module@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        James Morris <james.l.morris@oracle.com>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH 2/3] Smack: handle zero-length security labels without
 panic
References: <20140807165233.13463.55258.stgit@buzz> <20140807165243.13463.74200.stgit@buzz> <20140808202549.GA25352@mail.hallyn.com> <CALYGNiMyYmBHnuUWFuwOhg2k-wYJdbEHWqM8DpHZAebDuT9ZVA@mail.gmail.com> <20140808205425.GE25352@mail.hallyn.com>
In-Reply-To: <20140808205425.GE25352@mail.hallyn.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/8/2014 1:54 PM, Serge E. Hallyn wrote:
> Quoting Konstantin Khlebnikov (koct9i@gmail.com):
>> On Sat, Aug 9, 2014 at 12:25 AM, Serge E. Hallyn <serge@hallyn.com> wrote:
>>> Quoting Konstantin Khlebnikov (k.khlebnikov@samsung.com):
>>>> Zero-length security labels are invalid but kernel should handle them.
>>>>
>>>> This patch fixes kernel panic after setting zero-length security labels:
>>>> # attr -S -s "SMACK64" -V "" file
>>>>
>>>> And after writing zero-length string into smackfs files syslog and onlycp:
>>>> # python -c 'import os; os.write(1, "")' > /smack/syslog
>>>>
>>>> The problem is caused by brain-damaged logic in function smk_parse_smack()
>>>> which takes pointer to buffer and its length but if length below or equal zero
>>>> it thinks that the buffer is zero-terminated. Unfortunately callers of this
>>>> function are widely used and proper fix requires serious refactoring.
>>>>
>>>> Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
>>> Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
>>>
>>>> ---
>>>>
>>>> Example:
>>>>
>>>> [   28.063935] BUG: unable to handle kernel NULL pointer dereference at           (null)
>>>> [   28.064623] IP: [<ffffffff812ea780>] strlen+0x0/0x30
>>>> [   28.064623] PGD 29a77067 PUD 2972d067 PMD 0
>>>> [   28.064623] Oops: 0000 [#1] SMP
>>>> [   28.064623] Modules linked in:
>>>> [   28.064623] CPU: 0 PID: 824 Comm: attr Not tainted 3.16.0+ #6
>>>> [   28.064623] task: ffff880029bd88c0 ti: ffff8800297d0000 task.ti: ffff8800297d0000
>>>> [   28.064623] RIP: 0010:[<ffffffff812ea780>]  [<ffffffff812ea780>] strlen+0x0/0x30
>>>> [   28.064623] RSP: 0018:ffff8800297d3ca8  EFLAGS: 00010246
>>>> [   28.064623] RAX: 0000000000000001 RBX: ffff880029c096c0 RCX: 0000000000000001
>>>> [   28.064623] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
>>>> [   28.064623] RBP: ffff8800297d3cd0 R08: ffffffff81e3d940 R09: ffff88002a3e8588
>>>> [   28.064623] R10: 8080808080808080 R11: 0000000000000000 R12: 0000000000000000
>>>> [   28.064623] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
>>>> [   28.064623] FS:  00007effe391a700(0000) GS:ffff88002a400000(0000) knlGS:0000000000000000
>>>> [   28.064623] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>> [   28.064623] CR2: 0000000000000000 CR3: 00000000297a1000 CR4: 00000000001406b0
>>>> [   28.064623] Stack:
>>>> [   28.064623]  ffffffff812a6fa5 ffff880029c096c0 0000000000000001 0000000000000000
>>>> [   28.064623]  0000000000000000 ffff8800297d3cf8 ffffffff812a70ae ffff880029c096c0
>>>> [   28.064623]  0000000000000001 0000000000000000 ffff8800297d3d88 ffffffff812a64dc
>>>> [   28.064623] Call Trace:
>>>> [   28.064623]  [<ffffffff812a6fa5>] ? smk_parse_smack+0xe5/0x110
>>>> [   28.064623]  [<ffffffff812a70ae>] smk_import_entry+0xe/0x130
>>>> [   28.064623]  [<ffffffff812a64dc>] smack_inode_setxattr+0x11c/0x280
>>>> [   28.064623]  [<ffffffff8116a767>] ? lookup_fast+0x177/0x2e0
>>>> [   28.064623]  [<ffffffff81177001>] ? dput+0x21/0x1a0
>>>> [   28.064623]  [<ffffffff812a0eeb>] security_inode_setxattr+0x1b/0x30
>>>> [   28.064623]  [<ffffffff8118488f>] vfs_setxattr+0x6f/0xb0
>>>> [   28.064623]  [<ffffffff81184a76>] setxattr+0x1a6/0x1f0
>>>> [   28.064623]  [<ffffffff8116af6d>] ? final_putname+0x1d/0x40
>>>> [   28.064623]  [<ffffffff8116b1c4>] ? putname+0x24/0x40
>>>> [   28.064623]  [<ffffffff8117144a>] ? user_path_at_empty+0x5a/0xa0
>>>> [   28.064623]  [<ffffffff81162b84>] ? __sb_start_write+0x44/0xe0
>>>> [   28.064623]  [<ffffffff8113cd21>] ? do_brk+0x241/0x320
>>>> [   28.064623]  [<ffffffff81184d97>] SyS_lsetxattr+0x87/0xe0
>>>> [   28.064623]  [<ffffffff81806f69>] system_call_fastpath+0x16/0x1b
>>>> [   28.064623] Code: 89 f8 48 89 e5 f6 82 40 3e a6 81 20 74 15 0f 1f 44 00 00 48 83 c0 01 0f b6 10 f6 82 40 3e a6 81 20 75 f0 5d c3 66 0f 1f 44 00 00 <80> 3f 00 55 48 89 e5 74 15 48 89 f8 0f 1f 40 00 48 83 c0 01 80
>>>> [   28.064623] RIP  [<ffffffff812ea780>] strlen+0x0/0x30
>>>> [   28.064623]  RSP <ffff8800297d3ca8>
>>>> [   28.064623] CR2: 0000000000000000
>>>> [   28.093561] ---[ end trace de1055429a98a5be ]---
>>>> ---
>>>>  security/smack/smack_lsm.c |    2 +-
>>>>  security/smack/smackfs.c   |    4 ++--
>>>>  2 files changed, 3 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
>>>> index b11ab23..afa5ad0 100644
>>>> --- a/security/smack/smack_lsm.c
>>>> +++ b/security/smack/smack_lsm.c
>>>> @@ -923,7 +923,7 @@ static int smack_inode_setxattr(struct dentry *dentry, const char *name,
>>>>               rc = -EPERM;
>>>>
>>>>       if (rc == 0 && check_import) {
>>>> -             skp = smk_import_entry(value, size);
>>>> +             skp = size ? smk_import_entry(value, size) : NULL;
>>>>               if (skp == NULL || (check_star &&
>>>>                   (skp == &smack_known_star || skp == &smack_known_web)))
>>>>                       rc = -EINVAL;
>>>> diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
>>>> index 3c720ff..56a1439 100644
>>>> --- a/security/smack/smackfs.c
>>>> +++ b/security/smack/smackfs.c
>>>> @@ -1677,7 +1677,7 @@ static ssize_t smk_write_onlycap(struct file *file, const char __user *buf,
>>>>       if (smack_onlycap != NULL && smack_onlycap != skp)
>>>>               return -EPERM;
>>>>
>>>> -     data = kzalloc(count, GFP_KERNEL);
>>>> +     data = kzalloc(count + 1, GFP_KERNEL);
>>>>       if (data == NULL)
>>>>               return -ENOMEM;
>>>>
>>>> @@ -2228,7 +2228,7 @@ static ssize_t smk_write_syslog(struct file *file, const char __user *buf,
>>>>       if (!smack_privileged(CAP_MAC_ADMIN))
>>>>               return -EPERM;
>>>>
>>> How about putting a comment here explaining that this way if len is 0 you
>>> make sure to have '\0' to avoid parsing problems?
>> There are plenty of these comments. That design is uncommon and
> Exactly why it should be documented.

The code was much simpler when I decided that a 0 length could
safely indicate that the string was known to be terminated. Several
other people have been in the code since, and it got crufted up
in the name of performance. Oh well.Thank you for taking the time to
provide a patch. I appreciate your efforts.

>
>> extremely dangerous,
>> it cannot be neutralized just by a comment.
> It's not about neutralizing it.  It's about down the road, while you're on leave
> for a few months, someone saying "say that +1 seems unnecessary, I'll just remove it."

I'd rather have a pass through the entirety of the label import code.
Some of the performance optimizations were done in a way that, while it
seemed like a good idea at the time, didn't necessarily demonstrate a
through understanding of what the surrounding code was up to.

>
>> Probably magic length '0' might be replaced with magic '-1' which is much safer.
> Could be.

Not a bad idea.

>
>>>> -     data = kzalloc(count, GFP_KERNEL);
>>>> +     data = kzalloc(count + 1, GFP_KERNEL);
>>>>       if (data == NULL)
>>>>               return -ENOMEM;
>>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

