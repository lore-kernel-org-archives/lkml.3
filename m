Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbbASSCb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 13:02:31 -0500
Received: from hygieia.santi-shop.eu ([78.46.175.2]:50712 "EHLO
	hygieia.santi-shop.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435AbbASSC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 13:02:28 -0500
Date: Mon, 19 Jan 2015 19:02:16 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux 3.19-rc5
Message-ID: <20150119190216.7ce58d74@neptune.home>
In-Reply-To: <CA+55aFxNk9OCXz7nvKXpRBc0Z85NLXPNkRm1yJf4-KAGB4pHRA@mail.gmail.com>
References: <CA+55aFxNk9OCXz7nvKXpRBc0Z85NLXPNkRm1yJf4-KAGB4pHRA@mail.gmail.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i686-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 January 2015 Linus Torvalds <torvalds@linux-foundation.org> wrote:
> Another week, another -rc.
> 
> Fairly normal release, although I'd wish that by rc5 we'd have calmed
> down even further.  But no, with some of the driver tree merges in
> particular, this is actually larger than rc4 was.
> 
> That said, it's not like there is anything particularly scary in here.
> 
> The arm64 vm bug that I mentioned as pending in the rc4 notes got
> fixed within a day of that previous rc release, and the rest looks
> pretty standard. Mostly drivers (networking, usb, scsi target, block
> layer, mmc,  tty etc), but also arch updates (arm, x86, s390 and some
> tiny powerpc fixes), some filesystem updates (fuse and nfs), tracing
> fixes, and some perf tooling fixes.
> 
> Shortlog with the details appended.
> 
> Go forth and test.

No idea yet which rc is the offender (nor exact patch), but on my not
so recent UP laptop with a pccard slot I have 2 pccardd kernel threads
converting my laptop into a heater.

lspci for affected nodes:
02:06.0 CardBus bridge [0607]: O2 Micro, Inc. OZ711EC1 SmartCardBus Controller [1217:7113] (rev 20)
02:06.1 CardBus bridge [0607]: O2 Micro, Inc. OZ711EC1 SmartCardBus Controller [1217:7113] (rev 20)


Very basics I have, before I attempt any bisection:

cat /proc/$(pidof pccardd)/stack
[<c143ec95>] pccardd+0x1a5/0x3e0
[<c10543a0>] kthread+0xa0/0xc0
[<c16cd840>] ret_from_kernel_thread+0x20/0x30
[<ffffffff>] 0xffffffff


Doing objdump on drivers/pcmcia/cs.o in which pccardd() is defined
it seems pccardd is stuck in try_to_freeze_unsafe().

Does this kind of behavior ring a bell?

I can unbind the two yenta_cardbus devices from yenta_cardbus to stop
the CPU usage.


Possibly important config option:
# CONFIG_SMP is not set




Objdump below:

static int pccardd(void *__skt)
{
     ca0:       55                      push   %ebp
     ca1:       89 e5                   mov    %esp,%ebp
     ca3:       57                      push   %edi
     ca4:       56                      push   %esi
     ca5:       53                      push   %ebx
     ca6:       89 c3                   mov    %eax,%ebx
     ca8:       83 ec 24                sub    $0x24,%esp

DECLARE_PER_CPU(struct task_struct *, current_task);

static __always_inline struct task_struct *get_current(void)
{
        return this_cpu_read_stable(current_task);
     cab:       a1 00 00 00 00          mov    0x0,%eax
        struct pcmcia_socket *skt = __skt;
        int ret;

        skt->thread = current;
     cb0:       89 83 e4 00 00 00       mov    %eax,0xe4(%ebx)
        skt->socket = dead_socket;
     cb6:       a1 00 00 00 00          mov    0x0,%eax
        skt->ops->init(skt);
     cbb:       8b 93 cc 00 00 00       mov    0xcc(%ebx),%edx
{
        struct pcmcia_socket *skt = __skt;
        int ret;

        skt->thread = current;
        skt->socket = dead_socket;
     cc1:       89 43 04                mov    %eax,0x4(%ebx)
     cc4:       a1 04 00 00 00          mov    0x4,%eax
     cc9:       89 43 08                mov    %eax,0x8(%ebx)
     ccc:       a1 08 00 00 00          mov    0x8,%eax
     cd1:       89 43 0c                mov    %eax,0xc(%ebx)
        skt->ops->init(skt);
     cd4:       89 d8                   mov    %ebx,%eax
     cd6:       ff 12                   call   *(%edx)
        skt->ops->set_socket(skt, &skt->socket);
     cd8:       8b 8b cc 00 00 00       mov    0xcc(%ebx),%ecx
     cde:       8d 53 04                lea    0x4(%ebx),%edx
     ce1:       89 d8                   mov    %ebx,%eax
     ce3:       ff 51 0c                call   *0xc(%ecx)

        /* register with the device core */
        ret = device_register(&skt->dev);
     ce6:       8d 83 2c 01 00 00       lea    0x12c(%ebx),%eax
     cec:       89 45 e0                mov    %eax,-0x20(%ebp)
     cef:       e8 fc ff ff ff          call   cf0 <pccardd+0x50>
        if (ret) {
     cf4:       85 c0                   test   %eax,%eax
     cf6:       0f 85 d4 02 00 00       jne    fd0 <pccardd+0x330>
                           "PCMCIA: unable to register socket\n");
                skt->thread = NULL;
                complete(&skt->thread_done);
                return 0;
        }
        ret = pccard_sysfs_add_socket(&skt->dev);
     cfc:       8b 45 e0                mov    -0x20(%ebp),%eax
     cff:       e8 fc ff ff ff          call   d00 <pccardd+0x60>
        if (ret)
     d04:       85 c0                   test   %eax,%eax
                           "PCMCIA: unable to register socket\n");
                skt->thread = NULL;
                complete(&skt->thread_done);
                return 0;
        }
        ret = pccard_sysfs_add_socket(&skt->dev);
     d06:       89 45 e4                mov    %eax,-0x1c(%ebp)
        if (ret)
     d09:       0f 85 01 03 00 00       jne    1010 <pccardd+0x370>
                dev_warn(&skt->dev, "err %d adding socket attributes\n", ret);

        complete(&skt->thread_done);
     d0f:       8d 83 e8 00 00 00       lea    0xe8(%ebx),%eax
     d15:       e8 fc ff ff ff          call   d16 <pccardd+0x76>

        /* wait for userspace to catch up */
        msleep(250);
     d1a:       b8 fa 00 00 00          mov    $0xfa,%eax
     d1f:       e8 fc ff ff ff          call   d20 <pccardd+0x80>

        set_freezable();
     d24:       e8 fc ff ff ff          call   d25 <pccardd+0x85>
     d29:       8d 83 fc 00 00 00       lea    0xfc(%ebx),%eax
     d2f:       8b 3d 00 00 00 00       mov    0x0,%edi
     d35:       89 45 e8                mov    %eax,-0x18(%ebp)
     d38:       89 7d dc                mov    %edi,-0x24(%ebp)
     d3b:       90                      nop
     d3c:       8d 74 26 00             lea    0x0(%esi,%eiz,1),%esi
        for (;;) {
                unsigned long flags;
                unsigned int events;
                unsigned int sysfs_events;

                set_current_state(TASK_INTERRUPTIBLE);
     d40:       be 40 0d 00 00          mov    $0xd40,%esi
     d45:       89 b7 8c 0c 00 00       mov    %esi,0xc8c(%edi)
     d4b:       c7 07 01 00 00 00       movl   $0x1,(%edi)
        /*
         * "=rm" is safe here, because "pop" adjusts the stack before
         * it evaluates its effective address -- this is part of the
         * documented behavior of the "pop" instruction.
         */
        asm volatile("# __raw_save_flags\n\t"
     d51:       9c                      pushf  
     d52:       58                      pop    %eax
                     :"memory", "cc");
}

static inline void native_irq_disable(void)
{
        asm volatile("cli": : :"memory");
     d53:       fa                      cli    
 * The various preempt_count add/sub methods
 */

static __always_inline void __preempt_count_add(int val)
{
        raw_cpu_add_4(__preempt_count, val);
     d54:       ff 05 00 00 00 00       incl   0x0

                spin_lock_irqsave(&skt->thread_lock, flags);
                events = skt->thread_events;
     d5a:       8b 8b f4 00 00 00       mov    0xf4(%ebx),%ecx
                skt->thread_events = 0;
     d60:       31 d2                   xor    %edx,%edx
                sysfs_events = skt->sysfs_events;
     d62:       8b b3 f8 00 00 00       mov    0xf8(%ebx),%esi

                set_current_state(TASK_INTERRUPTIBLE);

                spin_lock_irqsave(&skt->thread_lock, flags);
                events = skt->thread_events;
                skt->thread_events = 0;
     d68:       89 93 f4 00 00 00       mov    %edx,0xf4(%ebx)
                unsigned int sysfs_events;

                set_current_state(TASK_INTERRUPTIBLE);

                spin_lock_irqsave(&skt->thread_lock, flags);
                events = skt->thread_events;
     d6e:       89 4d ec                mov    %ecx,-0x14(%ebp)
                skt->thread_events = 0;
                sysfs_events = skt->sysfs_events;
                skt->sysfs_events = 0;
     d71:       31 c9                   xor    %ecx,%ecx
     d73:       89 8b f8 00 00 00       mov    %ecx,0xf8(%ebx)
        return flags;
}

static inline void native_restore_fl(unsigned long flags)
{
        asm volatile("push %0 ; popf"
     d79:       50                      push   %eax
     d7a:       9d                      popf   
                spin_unlock_irqrestore(&skt->thread_lock, flags);

                mutex_lock(&skt->skt_mutex);
     d7b:       8b 45 e8                mov    -0x18(%ebp),%eax
}

static __always_inline void __preempt_count_sub(int val)
{
        raw_cpu_add_4(__preempt_count, -val);
     d7e:       ff 0d 00 00 00 00       decl   0x0
     d84:       e8 fc ff ff ff          call   d85 <pccardd+0xe5>
                if (events & SS_DETECT)
     d89:       f6 45 ec 80             testb  $0x80,-0x14(%ebp)
     d8d:       0f 85 f5 00 00 00       jne    e88 <pccardd+0x1e8>
                        socket_detect_change(skt);

                if (sysfs_events) {
     d93:       85 f6                   test   %esi,%esi
     d95:       0f 84 85 00 00 00       je     e20 <pccardd+0x180>
                        if (sysfs_events & PCMCIA_UEVENT_EJECT)
     d9b:       f7 c6 01 00 00 00       test   $0x1,%esi
     da1:       0f 85 21 01 00 00       jne    ec8 <pccardd+0x228>
                                socket_remove(skt);
                        if (sysfs_events & PCMCIA_UEVENT_INSERT)
     da7:       f7 c6 02 00 00 00       test   $0x2,%esi
     dad:       0f 85 28 01 00 00       jne    edb <pccardd+0x23b>
                                socket_insert(skt);
                        if ((sysfs_events & PCMCIA_UEVENT_SUSPEND) &&
     db3:       f7 c6 04 00 00 00       test   $0x4,%esi
     db9:       74 25                   je     de0 <pccardd+0x140>
     dbb:       f6 43 11 80             testb  $0x80,0x11(%ebx)
     dbf:       75 1f                   jne    de0 <pccardd+0x140>
                                !(skt->state & SOCKET_CARDBUS)) {
                                if (skt->callback)
     dc1:       8b 93 14 01 00 00       mov    0x114(%ebx),%edx
     dc7:       85 d2                   test   %edx,%edx
     dc9:       0f 84 e1 01 00 00       je     fb0 <pccardd+0x310>
                                        ret = skt->callback->suspend(skt);
     dcf:       89 d8                   mov    %ebx,%eax
     dd1:       ff 52 14                call   *0x14(%edx)
                                else
                                        ret = 0;
                                if (!ret) {
     dd4:       85 c0                   test   %eax,%eax
                        if (sysfs_events & PCMCIA_UEVENT_INSERT)
                                socket_insert(skt);
                        if ((sysfs_events & PCMCIA_UEVENT_SUSPEND) &&
                                !(skt->state & SOCKET_CARDBUS)) {
                                if (skt->callback)
                                        ret = skt->callback->suspend(skt);
     dd6:       89 45 e4                mov    %eax,-0x1c(%ebp)
                                else
                                        ret = 0;
                                if (!ret) {
     dd9:       0f 84 d1 01 00 00       je     fb0 <pccardd+0x310>
     ddf:       90                      nop
                                        socket_suspend(skt);
                                        msleep(100);
                                }
                        }
                        if ((sysfs_events & PCMCIA_UEVENT_RESUME) &&
     de0:       f7 c6 08 00 00 00       test   $0x8,%esi
     de6:       74 0c                   je     df4 <pccardd+0x154>
                                !(skt->state & SOCKET_CARDBUS)) {
     de8:       8b 43 10                mov    0x10(%ebx),%eax
                                if (!ret) {
                                        socket_suspend(skt);
                                        msleep(100);
                                }
                        }
                        if ((sysfs_events & PCMCIA_UEVENT_RESUME) &&
     deb:       f6 c4 80                test   $0x80,%ah
     dee:       0f 84 24 01 00 00       je     f18 <pccardd+0x278>
                                !(skt->state & SOCKET_CARDBUS)) {
                                ret = socket_resume(skt);
                                if (!ret && skt->callback)
                                        skt->callback->resume(skt);
                        }
                        if ((sysfs_events & PCMCIA_UEVENT_REQUERY) &&
     df4:       f7 c6 10 00 00 00       test   $0x10,%esi
     dfa:       74 24                   je     e20 <pccardd+0x180>
     dfc:       f6 43 11 80             testb  $0x80,0x11(%ebx)
     e00:       75 1e                   jne    e20 <pccardd+0x180>
                                !(skt->state & SOCKET_CARDBUS)) {
                                if (!ret && skt->callback)
     e02:       8b 4d e4                mov    -0x1c(%ebp),%ecx
     e05:       85 c9                   test   %ecx,%ecx
     e07:       75 17                   jne    e20 <pccardd+0x180>
     e09:       8b 93 14 01 00 00       mov    0x114(%ebx),%edx
     e0f:       85 d2                   test   %edx,%edx
     e11:       74 0d                   je     e20 <pccardd+0x180>
                                        skt->callback->requery(skt);
     e13:       89 d8                   mov    %ebx,%eax
     e15:       ff 52 0c                call   *0xc(%edx)
     e18:       90                      nop
     e19:       8d b4 26 00 00 00 00    lea    0x0(%esi,%eiz,1),%esi
                        }
                }
                mutex_unlock(&skt->skt_mutex);
     e20:       8b 45 e8                mov    -0x18(%ebp),%eax
     e23:       e8 fc ff ff ff          call   e24 <pccardd+0x184>

                if (events || sysfs_events)
     e28:       8b 45 ec                mov    -0x14(%ebp),%eax
     e2b:       09 f0                   or     %esi,%eax
     e2d:       0f 85 0d ff ff ff       jne    d40 <pccardd+0xa0>
                        continue;

                if (kthread_should_stop())
     e33:       e8 fc ff ff ff          call   e34 <pccardd+0x194>
     e38:       84 c0                   test   %al,%al
     e3a:       0f 85 30 01 00 00       jne    f70 <pccardd+0x2d0>
                        break;

                schedule();
     e40:       e8 fc ff ff ff          call   e41 <pccardd+0x1a1>
 * DO NOT ADD ANY NEW CALLERS OF THIS FUNCTION
 * If try_to_freeze causes a lockdep warning it means the caller may deadlock
 */
static inline bool try_to_freeze_unsafe(void)
{
        might_sleep();
     e45:       31 c9                   xor    %ecx,%ecx



Stack as obtained points to here.





     e47:       ba 38 00 00 00          mov    $0x38,%edx
     e4c:       b8 3c 01 00 00          mov    $0x13c,%eax
     e51:       e8 fc ff ff ff          call   e52 <pccardd+0x1b2>
     e56:       e8 fc ff ff ff          call   e57 <pccardd+0x1b7>
 *
 * Atomically reads the value of @v.
 */
static inline int atomic_read(const atomic_t *v)
{
        return ACCESS_ONCE((v)->counter);
     e5b:       a1 00 00 00 00          mov    0x0,%eax
/*
 * Check if there is a request to freeze a process
 */
static inline bool freezing(struct task_struct *p)
{
        if (likely(!atomic_read(&system_freezing_cnt)))
     e60:       85 c0                   test   %eax,%eax
     e62:       0f 84 d8 fe ff ff       je     d40 <pccardd+0xa0>
                return false;
        return freezing_slow_path(p);
     e68:       8b 45 dc                mov    -0x24(%ebp),%eax
     e6b:       e8 fc ff ff ff          call   e6c <pccardd+0x1cc>
 * If try_to_freeze causes a lockdep warning it means the caller may deadlock
 */
...
