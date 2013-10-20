Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751299Ab3JTKLB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 06:11:01 -0400
Received: from mail-wg0-f53.google.com ([74.125.82.53]:40855 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab3JTKK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 06:10:58 -0400
MIME-Version: 1.0
In-Reply-To: <CAG5DWojOsLa_SXaLR8_z4FVchqzwQM4vCNC_MUg27Z918ExPzw@mail.gmail.com>
References: <CAG5DWojOsLa_SXaLR8_z4FVchqzwQM4vCNC_MUg27Z918ExPzw@mail.gmail.com>
Date: Sun, 20 Oct 2013 14:10:56 +0400
X-Google-Sender-Auth: MUinyFocp45a1oI4hgHISO85wyk
Message-ID: <CAG5DWoidrQiWJpcyzoXseXc8F2h2oLzBbN16FtGQBSTbPtSiGg@mail.gmail.com>
Subject: Re: adjust /proc/PID/oom_score_adj with CAP_SYS_RESOURCE
From: Azat Khuzhin <a.khuzhin@semrush.com>
To: open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 20, 2013 at 12:33 AM, Azat Khuzhin <a.khuzhin@semrush.com> wrote:
> Recently I needed in adjusting /proc/PID/oom_score_adj to disable oom killer,
> but I didn't want to add suid/or run from root that binary.
>
> I decided to use CAP_SYS_RESOURCE. However it didn't work.
>
> I gdb/strace/printk a lot, and finally found the reason,
> the process can't open this file for writing because pid_revalidate()
> change i_uid/i_gid for it to GLOBAL_ROOT_UID/GID.

Here is some more information:

For binary with CAP_SYS_RESOURCE we have
Breakpoint 17, pid_revalidate
(gdb) p task->mm->flags
$85 = 204
(gdb) p (task->mm->flags & 3)
$86 = 0
(gdb) p (task->mm->flags & 3) > 1 ? 2 : 0
$87 = 0

For binary without:
Breakpoint 17, pid_revalidate
(gdb) p task->mm->flags
$85 = 205
(gdb) p (task->mm->flags & 3)
$86 = 1
(gdb) p (task->mm->flags & 3) > 1 ? 2 : 1
$87 = 1

(Where 3 is MMF_DUMPABLE_MASK.)
In pid_revalidate() checks does $87 != 0, if so, set i_{uid,gid} from
cred, otherwise set it to 0.

And that's why process can open "oom_score_adj" without capabilities
(but can't write to it)

> And to bypass this check I must to use CAP_DAC_OVERRIDE, which is not so good,
> because this will allow more capabilities than I need for that binary.
>
> Is this works by design,
> and/or is there another way to do this without suid/root?
>
> Thanks!
>
> --
> Respectfully
> Azat Khuzhin



-- 
Respectfully
Azat Khuzhin
