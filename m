Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161441AbaJaAHp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 20:07:45 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:35740 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161331AbaJaAHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 20:07:43 -0400
MIME-Version: 1.0
In-Reply-To: <1414676335-20203-1-git-send-email-kever.yang@rock-chips.com>
References: <1414676335-20203-1-git-send-email-kever.yang@rock-chips.com>
Date: Thu, 30 Oct 2014 17:07:42 -0700
X-Google-Sender-Auth: 34Tn8kSxS7AkEsWl-B6wafZnMZw
Message-ID: <CAD=FV=W50mhdGqyqFrGrcD3gRSyQ42fww6NC+E6BhRb6dk5toQ@mail.gmail.com>
Subject: Re: [PATCH v2] clk: rockchip: disable unused clocks
From: Doug Anderson <dianders@chromium.org>
To: Kever Yang <kever.yang@rock-chips.com>
Cc: Heiko Stuebner <heiko@sntech.de>, Sonny Rao <sonnyrao@chromium.org>,
        Addy Ke <addy.ke@rock-chips.com>, Eddie Cai <cf@rock-chips.com>,
        Jianqun Xu <xjq@rock-chips.com>, han jiang <hj@rock-chips.com>,
        =?UTF-8?B?5oi05YWL6ZyWIChKYWNrKQ==?= <dkl@rock-chips.com>,
        Tao Huang <huangtao@rock-chips.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Mike Turquette <mturquette@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris <zyw@rock-chips.com>, Dmitry Torokhov <dtor@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kever,

On Thu, Oct 30, 2014 at 6:38 AM, Kever Yang <kever.yang@rock-chips.com> wrote:
> The rockchip clock driver use CLK_IGNORE_UNUSED flag to make sure
> all the clocks are available like default power on state.
> We have implement the clock manage in most of rockchip drivers,
> it is time to remove it for power save.
> Instead we add CLK_IGNORE_UNUSED for some clock nodes which should
> be on during boot or no module driver in kernel will initialize it.
>
> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
> ---
>
> Changes in v2:
> - get some clock ID back
> - add CLK_IGNORE_UNUSED tag for aclk_strc and aclk_core in clk-rk3188.c
> - add CLK_IGNORE_UNUSED tag for rk3288 dwc2
>
>  drivers/clk/rockchip/clk-rk3188.c |  36 +++++-----
>  drivers/clk/rockchip/clk-rk3288.c | 148 +++++++++++++++++++-------------------
>  drivers/clk/rockchip/clk.c        |   9 ---
>  3 files changed, 92 insertions(+), 101 deletions(-)

A few more regressions introduced by your patch:

* When testing suspend/resume _without_ going into "DEEP" mode, I get
a crash on resume.  The crash is "fixed" with:

-       COMPOSITE_NOMUX(0, "pclk_dbg_pre", "armclk", CLK_IGNORE_UNUSED,
+       COMPOSITE_NOMUX(0, "pclk_dbg_pre", "armclk", 0,

-       GATE(0, "cs_dbg", "pclk_dbg_pre", CLK_IGNORE_UNUSED,
+       GATE(0, "cs_dbg", "pclk_dbg_pre", 0,

I haven't dug into what the heck is going on yet (and I'm not sure you
should include the above in your patch), but the crash looks like:

    [   18.640025] CPU1: shutdown
    [   18.643304] CPU2: shutdown
    [   18.646490] CPU3: shutdown
    [   18.649537] Internal error: Oops - undefined instruction: 0 [#1] SMP ARM

    Entering kdb (current=0xed7a9e00, pid 2549) on processor 0 Oops: (null)
    due to oops @ 0xc010f074

    dCPU: 0 PID: 2549 Comm: cat Not tainted 3.14.0 #455
    dtask: ed7a9e00 ti: ecd38000 task.ti: ecd38000
    PC is at reset_ctrl_regs+0xb0/0x27c
    LR is at dbg_cpu_pm_notify+0x24/0x2c
    pc : [<c010f074>]    lr : [<c010f264>]    psr: 60000193
    sp : ecd39d70  ip : ecd39d98  fp : ecd39d94
    r10: c0b08fb8  r9 : ecd39e54  r8 : 00000000
    r7 : ecd38030  r6 : 00000002  r5 : c0b4a37c  r4 : 00000000
    r3 : 00000000  r2 : 00000000  r1 : 00000002  r0 : 00000000
    Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment user
    Control: 10c5387d  Table: 2db6806a  DAC: 00000015
    dCPU: 0 PID: 2549 Comm: cat Not tainted 3.14.0 #455
    [<c010e26c>] (unwind_backtrace) from [<c010a3cc>] (show_stack+0x20/0x24)
    [<c010a3cc>] (show_stack) from [<c0610fcc>] (dump_stack+0x78/0x94)
    [<c0610fcc>] (dump_stack) from [<c0107438>] (show_regs+0x2c/0x34)
    [<c0107438>] (show_regs) from [<c0195270>] (kdb_dumpregs+0x38/0x60)
    [<c0195270>] (kdb_dumpregs) from [<c0198534>] (kdb_main_loop+0x210/0x668)
    [<c0198534>] (kdb_main_loop) from [<c019b30c>] (kdb_stub+0x298/0x3cc)
    [<c019b30c>] (kdb_stub) from [<c0191ae0>] (kgdb_cpu_enter+0x1c4/0x60c)
    [<c0191ae0>] (kgdb_cpu_enter) from [<c01921fc>]
(kgdb_handle_exception+0x194/0x1c8)
    [<c01921fc>] (kgdb_handle_exception) from [<c010d930>]
(kgdb_notify+0x38/0x50)
    [<c010d930>] (kgdb_notify) from [<c0142688>] (notifier_call_chain+0x50/0x78)
    [<c0142688>] (notifier_call_chain) from [<c014270c>]
(atomic_notifier_call_chain+0x2c/0x34)
    [<c014270c>] (atomic_notifier_call_chain) from [<c0142c64>]
(notify_die+0x4c/0x70)
    [<c0142c64>] (notify_die) from [<c010a4f8>] (die+0x128/0x3e0)
    [<c010a4f8>] (die) from [<c010a80c>] (arm_notify_die+0x5c/0x60)
    [<c010a80c>] (arm_notify_die) from [<c01000a0>] (do_undefinstr+0xa0/0x1a4)
    [<c01000a0>] (do_undefinstr) from [<c010b02c>] (__und_svc_finish+0x0/0x14)
    Exception stack(0xecd39d28 to 0xecd39d70)
    9d20:                   00000000 00000002 00000000 00000000
00000000 c0b4a37c
    9d40: 00000002 ecd38030 00000000 ecd39e54 c0b08fb8 ecd39d94
ecd39d98 ecd39d70
    9d60: c010f264 c010f074 60000193 ffffffff
    [<c010b02c>] (__und_svc_finish) from [<c010f074>]
(reset_ctrl_regs+0xb0/0x27c)
    [<c010f074>] (reset_ctrl_regs) from [<c010f264>]
(dbg_cpu_pm_notify+0x24/0x2c)
    [<c010f264>] (dbg_cpu_pm_notify) from [<c0142688>]
(notifier_call_chain+0x50/0x78)
    [<c0142688>] (notifier_call_chain) from [<c0142770>]
(__raw_notifier_call_chain+0x24/0x2c)
    [<c0142770>] (__raw_notifier_call_chain) from [<c01c2e2c>]
(cpu_pm_notify+0x34/0x50)
    [<c01c2e2c>] (cpu_pm_notify) from [<c01c2f00>] (cpu_pm_exit+0x30/0x48)
    [<c01c2f00>] (cpu_pm_exit) from [<c01c302c>] (cpu_pm_resume+0x1c/0x20)
    [<c01c302c>] (cpu_pm_resume) from [<c03d9234>] (syscore_resume+0x84/0xe4)
    [<c03d9234>] (syscore_resume) from [<c01628a0>]
(suspend_devices_and_enter+0x2e0/0x438)
    [<c01628a0>] (suspend_devices_and_enter) from [<c0162b08>]
(pm_suspend+0x110/0x214)
    [<c0162b08>] (pm_suspend) from [<c0161790>] (state_store+0xbc/0xd0)
    [<c0161790>] (state_store) from [<c0325ccc>] (kobj_attr_store+0x1c/0x28)
    [<c0325ccc>] (kobj_attr_store) from [<c026daac>] (sysfs_kf_write+0x4c/0x58)
    [<c026daac>] (sysfs_kf_write) from [<c0270e38>]
(kernfs_fop_write+0xfc/0x14c)
    [<c0270e38>] (kernfs_fop_write) from [<c02104d4>] (vfs_write+0xdc/0x18c)
    [<c02104d4>] (vfs_write) from [<c0210a98>] (SyS_write+0x58/0xb0)
    [<c0210a98>] (SyS_write) from [<c0106380>] (ret_fast_syscall+0x0/0x30)


I'm also having trouble going into "deep" suspend (which doesn't work
fully yet anyway) even after I fix the above.  Specifically _without_
this patch deep suspend takes up much less power than with this patch.
That one looks like it might involve more clocks.  Right now I usually
get low power if I leave all gate clocks on and disable these
composite clocks (ran out of time to confirm, to check the gates, to
double check, etc, but I can try to continue next week):

-       COMPOSITE(0, "aclk_vepu", mux_pll_src_cpll_gpll_usb480m_p, 0,
+       COMPOSITE(0, "aclk_vepu", mux_pll_src_cpll_gpll_usb480m_p,
CLK_IGNORE_UNUSED,

-       COMPOSITE(0, "aclk_vdpu", mux_pll_src_cpll_gpll_usb480m_p, 0,
+       COMPOSITE(0, "aclk_vdpu", mux_pll_src_cpll_gpll_usb480m_p,
CLK_IGNORE_UNUSED,

-       COMPOSITE(0, "aclk_rga_pre", mux_pll_src_cpll_gpll_usb480m_p, 0,
+       COMPOSITE(0, "aclk_rga_pre", mux_pll_src_cpll_gpll_usb480m_p,
CLK_IGNORE_UNUSED,

-       COMPOSITE(SCLK_RGA, "sclk_rga", mux_pll_src_cpll_gpll_usb480m_p, 0,
+       COMPOSITE(SCLK_RGA, "sclk_rga",
mux_pll_src_cpll_gpll_usb480m_p, CLK_IGNORE_UNUSED,

-       COMPOSITE(ACLK_HEVC, "aclk_hevc", mux_pll_src_cpll_gpll_npll_p, 0,
+       COMPOSITE(ACLK_HEVC, "aclk_hevc",
mux_pll_src_cpll_gpll_npll_p, CLK_IGNORE_UNUSED,

-       COMPOSITE(SCLK_HEVC_CABAC, "sclk_hevc_cabac",
mux_pll_src_cpll_gpll_npll_p, 0,
+       COMPOSITE(SCLK_HEVC_CABAC, "sclk_hevc_cabac",
mux_pll_src_cpll_gpll_npll_p, CLK_IGNORE_UNUSED,

-       COMPOSITE(SCLK_HEVC_CORE, "sclk_hevc_core",
mux_pll_src_cpll_gpll_npll_p, 0,
+       COMPOSITE(SCLK_HEVC_CORE, "sclk_hevc_core",
mux_pll_src_cpll_gpll_npll_p, CLK_IGNORE_UNUSED,


I could believe that some of these problems have to do with the power
domain patches, but I have in no way confirmed that.

-Doug
