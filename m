Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612AbaJGLeM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 07:34:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:51399 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094AbaJGLeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 07:34:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,670,1406617200"; 
   d="scan'208";a="610753838"
Date: Tue, 7 Oct 2014 19:33:11 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: LKP <lkp@01.org>, Yuanhan Liu <yuanhan.liu@intel.com>,
        linux-kernel@vger.kernel.org, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>
Subject: Re: [LKP] [x86LKP] PANIC: double fault, error_code:
 0xffffffffffffffff
Message-ID: <20141007113311.GD16301@wfg-t540p.sh.intel.com>
References: <20141004134729.GB5214@wfg-t540p.sh.intel.com>
 <20141005063802.GE3264@tassilo.jf.intel.com>
 <20141006203731.GF3264@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141006203731.GF3264@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Mon, Oct 06, 2014 at 01:37:31PM -0700, Andi Kleen wrote:
> 
> I cannot reproduce with the config/kvm script. 
> 
> Well the user space in your initrd hangs after boot, but I presume that's some
> different issue.

It should not be hang, but is taking some time to do the tests, and will reboot
after about 1 minute:

[    1.047088] Write protecting the kernel read-only data: 10240k
[    1.050967] Freeing unused kernel memory: 1248K (ffff8800014c8000 - ffff880001600000)
[    1.056489] Freeing unused kernel memory: 1936K (ffff88000181c000 - ffff880001a00000)
[    1.061008] random: init urandom read with 3 bits of entropy available
[   62.208919] reboot: Restarting system

As the table shows, it's not an easily reproducible bug -- the possibility is
less than 10%:

+------------------------------------------+------------+------------+------------+
|                                          | 598d570a05 | b8a868e9ea | 8048975233 |
+------------------------------------------+------------+------------+------------+
| boot_successes                           | 900        | 280        | 79         |
| boot_failures                            | 0          | 20         | 2          |
| PANIC:double_fault,                      | 0          | 12         | 2          |
| Kernel_panic-not_syncing:Machine_halted  | 0          | 11         | 2          |
| BUG:unable_to_handle_kernel              | 0          | 5          |            |
| Oops                                     | 0          | 3          |            |
| RIP:pgd_free                             | 0          | 1          |            |
| BUG:kernel_boot_crashed                  | 0          | 4          |            |
| RIP:show_stack_log_lvl                   | 0          | 1          |            |
| Kernel_panic-not_syncing:Fatal_exception | 0          | 1          |            |
+------------------------------------------+------------+------------+------------+

> Do you have a different config or setup that shows it too?

The next email report titled "[x86] double fault: ffff [#1]" happens on another
config and it has much better reproduce ratio:

+-------------------------------------------------------+------------+------------+------------------+
|                                                       | 598d570a05 | b8a868e9ea | v3.17-rc7_100409 |
+-------------------------------------------------------+------------+------------+------------------+
| boot_successes                                        | 207        | 24         | 17               |
| boot_failures                                         | 3          | 46         | 4                |
| BUG:kernel_boot_crashed                               | 3          |            |                  |
| double_fault:ffff                                     | 0          | 39         | 4                |
| RIP:trace_hardirqs_off_thunk                          | 0          | 22         | 1                |
| BUG:unable_to_handle_kernel                           | 0          | 17         | 1                |
| Oops                                                  | 0          | 15         | 1                |
| RIP:show_stack_log_lvl                                | 0          | 14         | 1                |
| Kernel_panic-not_syncing:Fatal_exception_in_interrupt | 0          | 20         | 2                |
| RIP:trace_hardirqs_off_caller                         | 0          | 6          | 1                |
| BUG:kernel_boot_hang                                  | 0          | 23         | 2                |
| backtrace:rescuer_thread                              | 0          | 1          |                  |
+-------------------------------------------------------+------------+------------+------------------+

You can use the same script to reproduce it. Only the kernel needs
rebuild with the attached config in that email.

Thanks,
Fengguang
