Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932470Ab3LXDA4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 22:00:56 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:64575 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932254Ab3LXDAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 22:00:54 -0500
MIME-Version: 1.0
In-Reply-To: <52B8F678.2090604@hitachi.com>
References: <20131220094134.24233.2969.stgit@yunodevel> <CAPXgP11H7EB5Sfezf_7NkKzXT4n4EnPPyE2wWV9YQmR=3LsbAw@mail.gmail.com>
 <52B8F678.2090604@hitachi.com>
From: Kay Sievers <kay@vrfy.org>
Date: Tue, 24 Dec 2013 04:00:33 +0100
Message-ID: <CAPXgP11FbLbWs3GoHpYngAGJ+whe8PZ=5dXqR8ufdMkLT5AX0Q@mail.gmail.com>
Subject: Re: Re: [PATCH 0/2] [BUGFIX] printk: Fix message continuation
 breakage involved with structured printk
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Eiichi Tsukata <eiichi.tsukata.xh@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Tejun Heo <tj@kernel.org>,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 24, 2013 at 3:50 AM, Yoshihiro YUNOMAE
<yoshihiro.yunomae.ez@hitachi.com> wrote:
> (2013/12/20 20:29), Kay Sievers wrote:
>>
>> On Fri, Dec 20, 2013 at 10:41 AM, Yoshihiro YUNOMAE
>> <yoshihiro.yunomae.ez@hitachi.com> wrote:
>>
>>> This patch set fixes message continuation breakage involved with
>>> structured
>>> printk. A SCSI driver may output two continuation error messages like
>>>      scmd_printk("foo");
>>>      printf("bar\n");
>>
>>
>> Which is the absolutely wrong thing to do. Structured logging and racy
>> printk continuation must never be mixed. Userspace needs to be sure
>> that dictionary entries are not subject to racy continuation hackery,
>> and that these mwssages atomic, whole and intact.
>
>
> I see.
> As you say, user tools need to support messages output in multiple lines
> for SMP environments even if this patch set is introduced.

They cannot really, they can try to re-construct, but Information and
context is sometimes lost with  the use of continuation lines.
Structured logging need to be reliable and trustable, and it it is not
"best effort", hence it cannot use continuation lines.

Continuation lines are a nice debugging tool for humans only.
Structured logging carries the human readable string but also
machine-readable context and that alwasy needs to be safely
machine-readable and recognizable.

>> Please do not mix the both and do not apply these patches.
>
> OK, I'll make important messages with KERN_CONT or no-prefix printk()
> output those in single line.

Yes, it should use the plain printk versions and not the one which add
structured data.

If structured logging is really wanted for more complex continuation
lines, it might be the simplest to buffer the line locally, instead of
the single printk-owned buffer, before the line is emitted to printk.
That way there will be no race with other print users but structured
data can still safely be added.

Kay
