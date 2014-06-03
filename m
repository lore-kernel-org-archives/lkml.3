Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314AbaFCVxg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 17:53:36 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:63323 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbaFCVxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 17:53:25 -0400
From: Peter Moody <pmoody@google.com>
To: <ananth@in.ibm.com>, <anil.s.keshavamurthy@intel.com>,
        <davem@davemloft.net>, <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Kees Cook <keescook@google.com>
Subject: Re: splat in kretprobe in get_task_mm(current)
References: <r3noay9dhad.fsf@perdido.sfo.corp.google.com>
Date: Tue, 03 Jun 2014 14:53:22 -0700
In-Reply-To: <r3noay9dhad.fsf@perdido.sfo.corp.google.com> (Peter Moody's
	message of "Tue\, 03 Jun 2014 10\:39\:06 -0700")
Message-ID: <r3nfvjld5il.fsf@perdido.sfo.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


As a follow up, I can reliably reproduce this bug with the following code

#include <unistd.h>
#include <sys/types.h>

int main(int argc, char *argv[]) {
  char *envp_[] = {NULL};
  char *argv_[] = {argv[0]};
  execve(argv[0], argv_, envp_);
  return 0;
}

run in parallel like so:

$ for x in $(seq 0 32) ; do ./a.out & done

giving me the following splat:.

[ 133.627336] BUG: spinlock cpu recursion on CPU#4, a.out/4643
[ 133.627346]  lock: kretprobe_table_locks+0x1b80/0x2000, .magic: dead4ead, .owner: a.out/4630, .owner_cpu: 4
[ 133.627350] CPU: 4 PID: 4643 Comm: a.out Tainted: G          IOE 3.15.0-rc8-splat+ #14
[ 133.627351] Hardware name: Dell Inc. Precision WorkStation T3500  /09KPNV, BIOS A10 01/21/2011
[ 133.627353]  ffff8804d5ae0000 ffff8804a7b4fd48 ffffffff81773413 0000000000000007
[ 133.627358]  ffffffff82843600 ffff8804a7b4fd68 ffffffff8176ec74 ffffffff82843600
[ 133.627362]  ffffffff81a8b6a6 ffff8804a7b4fd88 ffffffff8176ec9f ffffffff82843600
[ 133.627366] Call Trace:
[ 133.627372]  [<ffffffff81773413>] dump_stack+0x46/0x58
[ 133.627376]  [<ffffffff8176ec74>] spin_dump+0x8f/0x94
[ 133.627379]  [<ffffffff8176ec9f>] spin_bug+0x26/0x2b
[ 133.627384]  [<ffffffff810c4195>] do_raw_spin_lock+0x105/0x190
[ 133.627389]  [<ffffffff8177c7c0>] _raw_spin_lock_irqsave+0x70/0x90
[ 133.627394]  [<ffffffff817839dc>] ? kretprobe_hash_lock+0x6c/0x80
[ 133.627398]  [<ffffffff8177a86e>] ? mutex_unlock+0xe/0x10
[ 133.627401]  [<ffffffff817839dc>] kretprobe_hash_lock+0x6c/0x80
[ 133.627404]  [<ffffffff8177f16d>] trampoline_handler+0x3d/0x220
[ 133.627407]  [<ffffffff8177f0fe>] kretprobe_trampoline+0x25/0x57
[ 133.627412]  [<ffffffff811e28e8>] ? do_execve+0x18/0x20
[ 133.627415]  [<ffffffff817862a9>] stub_execve+0x69/0xa0

On Tue, Jun 03 2014 at 10:39, Peter Moody wrote:
> Hi folks,
>
> I've managed to trigger the following splat on 3.15.0-rc8 using the attached kretprobe module.
>
> [  339.208634] BUG: spinlock cpu recursion on CPU#4, rm/8733
> [  339.208643]  lock: kretprobe_table_locks+0x600/0x2000, .magic: dead4ead, .owner: rm/8734, .owner_cpu: 4
> [  339.208647] CPU: 4 PID: 8733 Comm: rm Tainted: G          IOE 3.15.0-rc8-splat+ #14
> [  339.208648] Hardware name: Dell Inc. Precision WorkStation T3500  /09KPNV, BIOS A10 01/21/2011
> [  339.208650]  ffff88044d3a2570 ffff880454e63d48 ffffffff81773413 0000000000000007
> [  339.208654]  ffffffff82842080 ffff880454e63d68 ffffffff8176ec74 ffffffff82842080
> [  339.208658]  ffffffff81a8b6a6 ffff880454e63d88 ffffffff8176ec9f ffffffff82842080
> [  339.208662] Call Trace:
> [  339.208667]  [<ffffffff81773413>] dump_stack+0x46/0x58
> [  339.208671]  [<ffffffff8176ec74>] spin_dump+0x8f/0x94
> [  339.208674]  [<ffffffff8176ec9f>] spin_bug+0x26/0x2b
> [  339.208678]  [<ffffffff810c4195>] do_raw_spin_lock+0x105/0x190
> [  339.208683]  [<ffffffff8177c7c0>] _raw_spin_lock_irqsave+0x70/0x90
> [  339.208687]  [<ffffffff817839dc>] ? kretprobe_hash_lock+0x6c/0x80
> [  339.208690]  [<ffffffff8177a86e>] ? mutex_unlock+0xe/0x10
> [  339.208693]  [<ffffffff817839dc>] kretprobe_hash_lock+0x6c/0x80
> [  339.208697]  [<ffffffff8177f16d>] trampoline_handler+0x3d/0x220
> [  339.208700]  [<ffffffff811bc537>] ? kfree+0x147/0x190
> [  339.208703]  [<ffffffff8177f0fe>] kretprobe_trampoline+0x25/0x57
> [  339.208707]  [<ffffffff811e28e8>] ? do_execve+0x18/0x20
> [  339.208710]  [<ffffffff817862a9>] stub_execve+0x69/0xa0
>
> Unfortunately triggering the splat is kind of a pain. I've only been able to it by building chromeos. The cros build
> process kicks off dozens of processes (in this case, it was 32) to fetch/build the various packages for the system
> image. I can try to come up with a better reproducer if this splat and module aren't enough.
>
> If I remove getting the reference to mm, I avoid the splat.
>
> Cheers,
> peter
>
>
> #include <linux/version.h>
> #include <linux/kernel.h>
> #include <linux/module.h>
> #include <linux/mm.h>
> #include <linux/kprobes.h>
>
> static int cntr;
>
> static int exec_handler(struct kretprobe_instance *ri, struct pt_regs *regs)
> {
>   int ret = (int)regs_return_value(regs);
>   if (!(unlikely(IS_ERR_VALUE(ret)))) {
>      struct mm_struct *mm = NULL;
>      mm = get_task_mm(current);
>      if (mm)
>        mmput(mm);
>   }
>   return 0;
> }
>
> static struct kretprobe exec_kretprobe = {
>   .kp.symbol_name = "do_execve",
>   .handler = exec_handler,
> };
>
> static int __init probe_init(void)
> {
>   int err;
>   if ((err = register_kretprobe(&exec_kretprobe))) {
>     pr_err("register failed: %d\n", err);
>     return err;
>   }
>   pr_info("exec_mm_probe loaded.\n");
>   cntr = 0;
>   return 0;
> }
>
> static void probe_exit(void)
> {
>   unregister_kretprobe(&exec_kretprobe);
>   pr_info("exec_mm_probe unloaded.\n");
> }
>
> MODULE_LICENSE("GPL v2");
>
> module_init(probe_init);
> module_exit(probe_exit);
