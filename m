Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758846Ab3BWUBa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 15:01:30 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:36111 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757022Ab3BWUB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 15:01:26 -0500
Message-ID: <51292038.3010100@gmail.com>
Date: Sat, 23 Feb 2013 15:02:00 -0500
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130113 Thunderbird/17.0.2
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Ilya Zykov <ilya@ilyx.ru>, Dave Jones <davej@redhat.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH v4 00/32] ldisc patchset
References: <1360095638-6624-1-git-send-email-peter@hurleysoftware.com>   <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>   <51261E30.9040907@gmail.com> <1361453910.10685.7.camel@thor.lan>  <1361558250.14402.6.camel@thor.lan> <5128DF40.7030003@gmail.com> <1361645001.3407.21.camel@thor.lan>
In-Reply-To: <1361645001.3407.21.camel@thor.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2013 01:43 PM, Peter Hurley wrote:
> On Sat, 2013-02-23 at 10:24 -0500, Sasha Levin wrote:
>> On 02/22/2013 01:37 PM, Peter Hurley wrote:
>>> On Thu, 2013-02-21 at 08:38 -0500, Peter Hurley wrote:
>>>> On Thu, 2013-02-21 at 08:16 -0500, Sasha Levin wrote:
>>>>> On 02/20/2013 03:02 PM, Peter Hurley wrote:
>>>>>> Sasha and Dave, my trinity testbeds die in other areas right now;
>>>>>> I would really appreciate if you would please re-test this series.
>>>>>
>>>>> Hi Peter,
>>>>>
>>>>> I saw this twice in overnight fuzzing:
>>>>>
>>>>> [ 1473.912280] =================================
>>>>> [ 1473.913180] [ BUG: bad contention detected! ]
>>>>> [ 1473.914071] 3.8.0-next-20130220-sasha-00038-g1ad55df-dirty #8 Tainted: G        W
>>>>> [ 1473.915684] ---------------------------------
>>>>> [ 1473.916549] kworker/1:1/361 is trying to contend lock (&tty->ldisc_sem) at:
>>>>> [ 1473.918031] [<ffffffff81c493df>] tty_ldisc_ref+0x1f/0x60
>>>>> [ 1473.919060] but there are no locks held!
>>>>
>>>> Ahh, of course. That explains why the rwsem trylock doesn't track lock
>>>> stats -- because by the time lock_contended() is called, up_write()
>>>> could have just called lockdep_release(), so that it appears as if the
>>>> lock has been released when in fact it has not but is about to.
>>>>
>>>> I'll just remove the lock contention test from the trylocks.
>>>
>>> Hi Sasha,
>>>
>>> Sorry for the delay. I was actually looking into if I could tickle
>>> lockdep into just recording the lock contention without testing, but
>>> unfortunately, changes to where lockdep stores the contention now
>>> requires the lockdep state to have an existing owner.
>>>
>>> So here's the trivial patch:
>>
>> Hi Peter,
>>
>> After more fuzzing, I'm seeing this sort of hangs (which are new):
>>
>> [ 2644.723879] INFO: task trinity:17893 blocked for more than 120 seconds.
>> [ 2644.727112] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> [ 2644.731916] trinity         D ffff8800a9c904a8  5192 17893   8043 0x00000000
>> [ 2644.733517]  ffff88006efb3a78 0000000000000002 ffff8800aa0c3b10 ffff8800bb3d7180
>> [ 2644.739350]  ffff880019103000 ffff880097a78000 ffff88006efb3a78 00000000001d7180
>> [ 2644.741459]  ffff880097a78000 ffff88006efb3fd8 00000000001d7180 00000000001d7180
>> [ 2644.746590] Call Trace:
>> [ 2644.747177]  [<ffffffff83db9909>] __schedule+0x2e9/0x3b0
>> [ 2644.748294]  [<ffffffff83db9b35>] schedule+0x55/0x60
>> [ 2644.752382]  [<ffffffff83db9e83>] schedule_preempt_disabled+0x13/0x20
>> [ 2644.753737]  [<ffffffff83db7fdd>] __mutex_lock_common+0x34d/0x560
>> [ 2644.759037]  [<ffffffff81c40893>] ? ptmx_open+0x83/0x190
>> [ 2644.760590]  [<ffffffff83db84b5>] ? __mutex_unlock_slowpath+0x185/0x1e0
>> [ 2644.762064]  [<ffffffff81c40893>] ? ptmx_open+0x83/0x190
>> [ 2644.768967]  [<ffffffff83db831f>] mutex_lock_nested+0x3f/0x50
>> [ 2644.770314]  [<ffffffff81c40893>] ptmx_open+0x83/0x190
>> [ 2644.771413]  [<ffffffff812917ae>] chrdev_open+0x11e/0x190
>> [ 2644.780456]  [<ffffffff81291690>] ? cdev_put+0x30/0x30
>> [ 2644.781421]  [<ffffffff8128af59>] do_dentry_open+0x1f9/0x310
>> [ 2644.785550]  [<ffffffff8128b0bc>] finish_open+0x4c/0x70
>> [ 2644.786724]  [<ffffffff8129c3eb>] do_last+0x61b/0x810
>> [ 2644.787676]  [<ffffffff8129c699>] path_openat+0xb9/0x4d0
>> [ 2644.791868]  [<ffffffff812ac278>] ? __alloc_fd+0x1e8/0x200
>> [ 2644.792817]  [<ffffffff81185214>] ? lock_release_nested+0xb4/0xf0
>> [ 2644.794010]  [<ffffffff81185331>] ? __lock_release+0xe1/0x100
>> [ 2644.797401]  [<ffffffff8129cebd>] do_filp_open+0x3d/0xa0
>> [ 2644.798467]  [<ffffffff812ac278>] ? __alloc_fd+0x1e8/0x200
>> [ 2644.799577]  [<ffffffff8128c51b>] do_sys_open+0x12b/0x1d0
>> [ 2644.804667]  [<ffffffff8128c5dc>] sys_open+0x1c/0x20
>> [ 2644.805542]  [<ffffffff83dc49d8>] tracesys+0xe1/0xe6
>> [ 2644.822807] 1 lock held by trinity/17893:
>> [ 2644.823685]  #0:  (tty_mutex){+.+.+.}, at: [<ffffffff81c40893>] ptmx_open+0x83/0x190
>>
>> The mutex is 'tty_mutex' at drivers/tty/pty.c:701 .
>>
>> I didn't grab sysrq-t this time since it was an overnight run, but I'll
>> try to grab one when it happens again.
> 
> Hi Sasha,
> 
> Can you please 'make drivers/tty/pty.lst'  for this kernel config and
> paste ptmx_open() here?
> 
> This report makes no sense: this stack trace shows this task waiting on
> a mutex that is not owned.

static int ptmx_open(struct inode *inode, struct file *filp)
{
 6c0:	55                   	push   %rbp
 6c1:	48 89 e5             	mov    %rsp,%rbp
 6c4:	48 83 ec 30          	sub    $0x30,%rsp
 6c8:	48 89 5d d8          	mov    %rbx,-0x28(%rbp)
 6cc:	48 89 f3             	mov    %rsi,%rbx
 6cf:	4c 89 65 e0          	mov    %r12,-0x20(%rbp)
 6d3:	49 89 fc             	mov    %rdi,%r12
 6d6:	4c 89 7d f8          	mov    %r15,-0x8(%rbp)
 6da:	4c 89 6d e8          	mov    %r13,-0x18(%rbp)
 6de:	4c 89 75 f0          	mov    %r14,-0x10(%rbp)
	struct tty_struct *tty;
	struct inode *slave_inode;
	int retval;
	int index;

	nonseekable_open(inode, filp);
 6e2:	e8 00 00 00 00       	callq  6e7 <ptmx_open+0x27>
			6e3: R_X86_64_PC32	nonseekable_open-0x4

	retval = tty_alloc_file(filp);
 6e7:	48 89 df             	mov    %rbx,%rdi
 6ea:	e8 00 00 00 00       	callq  6ef <ptmx_open+0x2f>
			6eb: R_X86_64_PC32	tty_alloc_file-0x4
	if (retval)
 6ef:	85 c0                	test   %eax,%eax
	int retval;
	int index;

	nonseekable_open(inode, filp);

	retval = tty_alloc_file(filp);
 6f1:	41 89 c7             	mov    %eax,%r15d
	if (retval)
 6f4:	0f 85 36 01 00 00    	jne    830 <ptmx_open+0x170>
		return retval;

	/* find a device that is not in use. */
	mutex_lock(&devpts_mutex);
 6fa:	31 f6                	xor    %esi,%esi
 6fc:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
			6ff: R_X86_64_32S	.data+0x20
 703:	e8 00 00 00 00       	callq  708 <ptmx_open+0x48>
			704: R_X86_64_PC32	mutex_lock_nested-0x4
	index = devpts_new_index(inode);
 708:	4c 89 e7             	mov    %r12,%rdi
 70b:	e8 00 00 00 00       	callq  710 <ptmx_open+0x50>
			70c: R_X86_64_PC32	devpts_new_index-0x4
	if (index < 0) {
		retval = index;
		mutex_unlock(&devpts_mutex);
 710:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
			713: R_X86_64_32S	.data+0x20
		return retval;

	/* find a device that is not in use. */
	mutex_lock(&devpts_mutex);
	index = devpts_new_index(inode);
	if (index < 0) {
 717:	85 c0                	test   %eax,%eax
	if (retval)
		return retval;

	/* find a device that is not in use. */
	mutex_lock(&devpts_mutex);
	index = devpts_new_index(inode);
 719:	41 89 c6             	mov    %eax,%r14d
	if (index < 0) {
 71c:	79 12                	jns    730 <ptmx_open+0x70>
		retval = index;
		mutex_unlock(&devpts_mutex);
 71e:	e8 00 00 00 00       	callq  723 <ptmx_open+0x63>
			71f: R_X86_64_PC32	mutex_unlock-0x4
		goto err_file;
 723:	45 89 f7             	mov    %r14d,%r15d
 726:	e9 fd 00 00 00       	jmpq   828 <ptmx_open+0x168>
 72b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
	}

	mutex_unlock(&devpts_mutex);
 730:	e8 00 00 00 00       	callq  735 <ptmx_open+0x75>
			731: R_X86_64_PC32	mutex_unlock-0x4

	mutex_lock(&tty_mutex);
 735:	31 f6                	xor    %esi,%esi
 737:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
			73a: R_X86_64_32S	tty_mutex
 73e:	e8 00 00 00 00       	callq  743 <ptmx_open+0x83>
			73f: R_X86_64_PC32	mutex_lock_nested-0x4
	tty = tty_init_dev(ptm_driver, index);
 743:	48 8b 3d 00 00 00 00 	mov    0x0(%rip),%rdi        # 74a <ptmx_open+0x8a>
			746: R_X86_64_PC32	.bss-0x4
 74a:	44 89 f6             	mov    %r14d,%esi
 74d:	e8 00 00 00 00       	callq  752 <ptmx_open+0x92>
			74e: R_X86_64_PC32	tty_init_dev-0x4

	if (IS_ERR(tty)) {
 752:	48 3d 00 f0 ff ff    	cmp    $0xfffffffffffff000,%rax
	}

	mutex_unlock(&devpts_mutex);

	mutex_lock(&tty_mutex);
	tty = tty_init_dev(ptm_driver, index);
 758:	49 89 c5             	mov    %rax,%r13

	if (IS_ERR(tty)) {
 75b:	76 23                	jbe    780 <ptmx_open+0xc0>
err_release:
	tty_unlock(tty);
	tty_release(inode, filp);
	return retval;
out:
	mutex_unlock(&tty_mutex);
 75d:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
			760: R_X86_64_32S	tty_mutex

	mutex_lock(&tty_mutex);
	tty = tty_init_dev(ptm_driver, index);

	if (IS_ERR(tty)) {
		retval = PTR_ERR(tty);
 764:	41 89 c7             	mov    %eax,%r15d
err_release:
	tty_unlock(tty);
	tty_release(inode, filp);
	return retval;
out:
	mutex_unlock(&tty_mutex);
 767:	e8 00 00 00 00       	callq  76c <ptmx_open+0xac>
			768: R_X86_64_PC32	mutex_unlock-0x4
	devpts_kill_index(inode, index);
 76c:	44 89 f6             	mov    %r14d,%esi
 76f:	4c 89 e7             	mov    %r12,%rdi
 772:	e8 00 00 00 00       	callq  777 <ptmx_open+0xb7>
			773: R_X86_64_PC32	devpts_kill_index-0x4
 777:	e9 ac 00 00 00       	jmpq   828 <ptmx_open+0x168>
 77c:	0f 1f 40 00          	nopl   0x0(%rax)
		goto out;
	}

	/* The tty returned here is locked so we can safely
	   drop the mutex */
	mutex_unlock(&tty_mutex);
 780:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
			783: R_X86_64_32S	tty_mutex
 787:	e8 00 00 00 00       	callq  78c <ptmx_open+0xcc>
			788: R_X86_64_PC32	mutex_unlock-0x4
 78c:	f0 41 80 8d da 03 00 	lock orb $0x1,0x3da(%r13)
 793:	00 01

	set_bit(TTY_PTY_LOCK, &tty->flags); /* LOCK THE SLAVE */
	tty->driver_data = inode;

	tty_add_file(tty, filp);
 795:	48 89 de             	mov    %rbx,%rsi
 798:	4c 89 ef             	mov    %r13,%rdi
	/* The tty returned here is locked so we can safely
	   drop the mutex */
	mutex_unlock(&tty_mutex);

	set_bit(TTY_PTY_LOCK, &tty->flags); /* LOCK THE SLAVE */
	tty->driver_data = inode;
 79b:	4d 89 a5 18 05 00 00 	mov    %r12,0x518(%r13)

	tty_add_file(tty, filp);
 7a2:	e8 00 00 00 00       	callq  7a7 <ptmx_open+0xe7>
			7a3: R_X86_64_PC32	tty_add_file-0x4

	slave_inode = devpts_pty_new(inode,
 7a7:	49 8b 8d f8 03 00 00 	mov    0x3f8(%r13),%rcx
			MKDEV(UNIX98_PTY_SLAVE_MAJOR, index), index,
 7ae:	44 89 f6             	mov    %r14d,%esi
 7b1:	81 ce 00 00 80 08    	or     $0x8800000,%esi
	set_bit(TTY_PTY_LOCK, &tty->flags); /* LOCK THE SLAVE */
	tty->driver_data = inode;

	tty_add_file(tty, filp);

	slave_inode = devpts_pty_new(inode,
 7b7:	44 89 f2             	mov    %r14d,%edx
 7ba:	4c 89 e7             	mov    %r12,%rdi
 7bd:	e8 00 00 00 00       	callq  7c2 <ptmx_open+0x102>
			7be: R_X86_64_PC32	devpts_pty_new-0x4
			MKDEV(UNIX98_PTY_SLAVE_MAJOR, index), index,
			tty->link);
	if (IS_ERR(slave_inode)) {
 7c2:	48 3d 00 f0 ff ff    	cmp    $0xfffffffffffff000,%rax
 7c8:	76 06                	jbe    7d0 <ptmx_open+0x110>
		retval = PTR_ERR(slave_inode);
 7ca:	41 89 c7             	mov    %eax,%r15d
		goto err_release;
 7cd:	eb 41                	jmp    810 <ptmx_open+0x150>
 7cf:	90                   	nop
	}
	tty->link->driver_data = slave_inode;
 7d0:	49 8b 95 f8 03 00 00 	mov    0x3f8(%r13),%rdx

	retval = ptm_driver->ops->open(tty, filp);
 7d7:	48 89 de             	mov    %rbx,%rsi
 7da:	4c 89 ef             	mov    %r13,%rdi
			tty->link);
	if (IS_ERR(slave_inode)) {
		retval = PTR_ERR(slave_inode);
		goto err_release;
	}
	tty->link->driver_data = slave_inode;
 7dd:	48 89 82 18 05 00 00 	mov    %rax,0x518(%rdx)

	retval = ptm_driver->ops->open(tty, filp);
 7e4:	48 8b 05 00 00 00 00 	mov    0x0(%rip),%rax        # 7eb <ptmx_open+0x12b>
			7e7: R_X86_64_PC32	.bss-0x4
 7eb:	48 8b 80 a0 00 00 00 	mov    0xa0(%rax),%rax
 7f2:	ff 50 18             	callq  *0x18(%rax)
	if (retval)
 7f5:	85 c0                	test   %eax,%eax
		retval = PTR_ERR(slave_inode);
		goto err_release;
	}
	tty->link->driver_data = slave_inode;

	retval = ptm_driver->ops->open(tty, filp);
 7f7:	41 89 c7             	mov    %eax,%r15d
	if (retval)
 7fa:	75 14                	jne    810 <ptmx_open+0x150>
		goto err_release;

	tty_unlock(tty);
 7fc:	4c 89 ef             	mov    %r13,%rdi
 7ff:	e8 00 00 00 00       	callq  804 <ptmx_open+0x144>
			800: R_X86_64_PC32	tty_unlock-0x4
	return 0;
 804:	eb 2a                	jmp    830 <ptmx_open+0x170>
 806:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
 80d:	00 00 00
err_release:
	tty_unlock(tty);
 810:	4c 89 ef             	mov    %r13,%rdi
 813:	e8 00 00 00 00       	callq  818 <ptmx_open+0x158>
			814: R_X86_64_PC32	tty_unlock-0x4
	tty_release(inode, filp);
 818:	48 89 de             	mov    %rbx,%rsi
 81b:	4c 89 e7             	mov    %r12,%rdi
 81e:	e8 00 00 00 00       	callq  823 <ptmx_open+0x163>
			81f: R_X86_64_PC32	tty_release-0x4
	return retval;
 823:	eb 0b                	jmp    830 <ptmx_open+0x170>
 825:	0f 1f 00             	nopl   (%rax)
out:
	mutex_unlock(&tty_mutex);
	devpts_kill_index(inode, index);
err_file:
	tty_free_file(filp);
 828:	48 89 df             	mov    %rbx,%rdi
 82b:	e8 00 00 00 00       	callq  830 <ptmx_open+0x170>
			82c: R_X86_64_PC32	tty_free_file-0x4
	return retval;
}
 830:	44 89 f8             	mov    %r15d,%eax
 833:	48 8b 5d d8          	mov    -0x28(%rbp),%rbx
 837:	4c 8b 65 e0          	mov    -0x20(%rbp),%r12
 83b:	4c 8b 6d e8          	mov    -0x18(%rbp),%r13
 83f:	4c 8b 75 f0          	mov    -0x10(%rbp),%r14
 843:	4c 8b 7d f8          	mov    -0x8(%rbp),%r15
 847:	c9                   	leaveq
 848:	c3                   	retq
 849:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)


Thanks,
Sasha

