Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391Ab3D3FRI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 01:17:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52262 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043Ab3D3FRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 01:17:06 -0400
Message-ID: <1367298972.4616.41.camel@marge.simpson.net>
Subject: Re: [patch v7 0/21] sched: power aware scheduling
From: Mike Galbraith <bitbucket@online.de>
To: Len Brown <lenb@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>, Alex Shi <alex.shi@intel.com>,
        mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, pjt@google.com,
        namhyung@kernel.org, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, len.brown@intel.com,
        rafael.j.wysocki@intel.com, jkosina@suse.cz, clark.williams@gmail.com,
        tony.luck@intel.com, keescook@chromium.org, mgorman@suse.de,
        riel@redhat.com, Linux PM list <linux-pm@vger.kernel.org>
Date: Tue, 30 Apr 2013 07:16:12 +0200
In-Reply-To: <1366989087.30242.11.camel@marge.simpson.net>
References: <1365040862-8390-1-git-send-email-alex.shi@intel.com>
	 <516724F5.20504@kernel.org> <5167C9FA.8050406@intel.com>
	 <20130412162348.GE2368@pd.tnic>
	 <1365785311.5814.36.camel@marge.simpson.net> <516F19EE.5060309@kernel.org>
	 <1366989087.30242.11.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:4P4H24Iqs7Mz0Ta0Y+CD4jb9NNOE8OJOWp6sJ8i/372
 8h8MS96/B0MwW7nASqbhhuJi3OXJRp9sI7Uxpn3yJ8noMv6laW
 Aetz6wJMt/7UjStax67CioK53fhscbXK9cb8seotiB9RCJlv5C
 5ZIEXyEeL9BIM9WaFkJYWMzqhPxLjFkl/nQd5vq2kCUD2ktyar
 2GSnnD11peKkEXbLxvssUSStuX+Qb7EWGZmZMS366CvCal/7lk
 ea6BldF/0e9doirrXa/BYdllqIeUp69YXdSRwCxSrsO+JV9o8Z
 704gqSzfOTQbRcwQLlBXJ9xQWPx/fBeOhVwYwoO4HVjsmsriEC
 zxg83U5Qoqmy14s3GyP9HoK9A/eYXELdvzpd+hYvLPfUDY5Lot
 LSg664tIiSXRA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-04-26 at 17:11 +0200, Mike Galbraith wrote: 
> On Wed, 2013-04-17 at 17:53 -0400, Len Brown wrote: 
> > On 04/12/2013 12:48 PM, Mike Galbraith wrote:
> > > On Fri, 2013-04-12 at 18:23 +0200, Borislav Petkov wrote: 
> > >> On Fri, Apr 12, 2013 at 04:46:50PM +0800, Alex Shi wrote:
> > >>> Thanks a lot for comments, Len!
> > >>
> > >> AFAICT, you kinda forgot to answer his most important question:
> > >>
> > >>> These numbers suggest that this patch series simultaneously
> > >>> has a negative impact on performance and energy required
> > >>> to retire the workload.  Why do it?
> > > 
> > > Hm.  When I tested AIM7 compute on a NUMA box, there was a marked
> > > throughput increase at the low to moderate load end of the test spectrum
> > > IIRC.  Fully repeatable.  There were also other benefits unrelated to
> > > power, ie mitigation of the evil face of select_idle_sibling().  I
> > > rather liked what I saw during ~big box test-drive.
> > > 
> > > (just saying there are other aspects besides joules in there)
> > 
> > Mike,
> > 
> > Can you re-run your AIM7 measurement with turbo-mode and HT-mode disabled,
> > and then independently re-enable them?
> > 
> > If you still see the performance benefit, then that proves
> > that the scheduler hacks are not about tricking into
> > turbo mode, but something else.
> 
> I did that today, neither turbo nor HT affected the performance gain.  I
> used the same box and patch set as tested before (v4), but plugged into
> linus HEAD.  "powersaving" AIM7 numbers are ~identical to those I posted
> before, "performance" is lower at the low end of AIM7 test spectrum, but
> as before, delta goes away once the load becomes hefty.

Well now, that's not exactly what I expected to see for AIM7 compute.
Filesystem is munching cycles otherwise used for compute when load is
spread across the whole box vs consolidated.

performance

   PerfTop:      35 irqs/sec  kernel:94.3%  exact:  0.0% [1000Hz cycles],  (all, 80 CPUs)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------                            

             samples  pcnt function                       DSO
             _______ _____ ______________________________ ________________________________________

             9367.00 15.5% jbd2_journal_put_journal_head  /lib/modules/3.9.0-default/build/vmlinux
             7658.00 12.7% jbd2_journal_add_journal_head  /lib/modules/3.9.0-default/build/vmlinux
             7042.00 11.7% jbd2_journal_grab_journal_head /lib/modules/3.9.0-default/build/vmlinux
             4433.00  7.4% sieve                          /abuild/mike/aim7/multitask             
             3248.00  5.4% jbd_lock_bh_state              /lib/modules/3.9.0-default/build/vmlinux
             3034.00  5.0% do_get_write_access            /lib/modules/3.9.0-default/build/vmlinux
             2058.00  3.4% mul_double                     /abuild/mike/aim7/multitask             
             2038.00  3.4% add_double                     /abuild/mike/aim7/multitask             
             1365.00  2.3% native_write_msr_safe          /lib/modules/3.9.0-default/build/vmlinux
             1333.00  2.2% __find_get_block               /lib/modules/3.9.0-default/build/vmlinux
             1213.00  2.0% add_long                       /abuild/mike/aim7/multitask             
             1208.00  2.0% add_int                        /abuild/mike/aim7/multitask             
             1084.00  1.8% __wait_on_bit_lock             /lib/modules/3.9.0-default/build/vmlinux
             1065.00  1.8% div_double                     /abuild/mike/aim7/multitask             
              901.00  1.5% intel_idle                     /lib/modules/3.9.0-default/build/vmlinux
              812.00  1.3% _raw_spin_lock_irqsave         /lib/modules/3.9.0-default/build/vmlinux
              559.00  0.9% jbd2_journal_dirty_metadata    /lib/modules/3.9.0-default/build/vmlinux
              464.00  0.8% copy_user_generic_string       /lib/modules/3.9.0-default/build/vmlinux
              455.00  0.8% div_int                        /abuild/mike/aim7/multitask             
              430.00  0.7% string_rtns_1                  /abuild/mike/aim7/multitask             
              419.00  0.7% strncat                        /lib64/libc-2.11.3.so                   
              412.00  0.7% wake_bit_function              /lib/modules/3.9.0-default/build/vmlinux
              347.00  0.6% jbd2_journal_cancel_revoke     /lib/modules/3.9.0-default/build/vmlinux
              346.00  0.6% ext4_mark_iloc_dirty           /lib/modules/3.9.0-default/build/vmlinux
              306.00  0.5% __brelse                       /lib/modules/3.9.0-default/build/vmlinux

powersaving

   PerfTop:      59 irqs/sec  kernel:78.0%  exact:  0.0% [1000Hz cycles],  (all, 80 CPUs)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------                            

             samples  pcnt function                       DSO
             _______ _____ ______________________________ ________________________________________

             6383.00 22.5% sieve                          /abuild/mike/aim7/multitask             
             2380.00  8.4% mul_double                     /abuild/mike/aim7/multitask             
             2375.00  8.4% add_double                     /abuild/mike/aim7/multitask             
             1678.00  5.9% add_long                       /abuild/mike/aim7/multitask             
             1633.00  5.8% add_int                        /abuild/mike/aim7/multitask             
             1338.00  4.7% div_double                     /abuild/mike/aim7/multitask             
              770.00  2.7% strncat                        /lib64/libc-2.11.3.so                   
              698.00  2.5% string_rtns_1                  /abuild/mike/aim7/multitask             
              678.00  2.4% copy_user_generic_string       /lib/modules/3.9.0-default/build/vmlinux
              569.00  2.0% div_int                        /abuild/mike/aim7/multitask             
              329.00  1.2% jbd2_journal_put_journal_head  /lib/modules/3.9.0-default/build/vmlinux
              306.00  1.1% array_rtns                     /abuild/mike/aim7/multitask             
              298.00  1.1% do_get_write_access            /lib/modules/3.9.0-default/build/vmlinux
              270.00  1.0% jbd2_journal_add_journal_head  /lib/modules/3.9.0-default/build/vmlinux
              258.00  0.9% _int_malloc                    /lib64/libc-2.11.3.so                   
              251.00  0.9% __find_get_block               /lib/modules/3.9.0-default/build/vmlinux
              236.00  0.8% __memset                       /lib/modules/3.9.0-default/build/vmlinux
              224.00  0.8% jbd2_journal_grab_journal_head /lib/modules/3.9.0-default/build/vmlinux
              221.00  0.8% intel_idle                     /lib/modules/3.9.0-default/build/vmlinux
              161.00  0.6% jbd_lock_bh_state              /lib/modules/3.9.0-default/build/vmlinux
              161.00  0.6% start_this_handle              /lib/modules/3.9.0-default/build/vmlinux
              153.00  0.5% __GI_memset                    /lib64/libc-2.11.3.so                   
              147.00  0.5% ext4_do_update_inode           /lib/modules/3.9.0-default/build/vmlinux
              135.00  0.5% jbd2_journal_stop              /lib/modules/3.9.0-default/build/vmlinux
              123.00  0.4% jbd2_journal_dirty_metadata    /lib/modules/3.9.0-default/build/vmlinux


performance

procs -----------memory---------- ---swap-- -----io---- -system-- -----cpu------
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
14  7      0 47716456 255124 674808    0    0     0     0 6183 93733  1  3 95  1  0
 0  0      0 47791912 255152 602068    0    0     0  2671 14526 49606  2  2 94  1  0
 1  0      0 47794384 255152 603796    0    0     0     0   68  111  0  0 100  0  0
 8  6      0 47672340 255156 730040    0    0     0     0 36249 103961  2  8 86  4  0
 0  0      0 47793976 255216 604616    0    0     0  2686 5322 6379  2  1 97  0  0
 0  0      0 47799128 255216 603108    0    0     0     0   62  106  0  0 100  0  0
 3  0      0 47795972 255300 603136    0    0     0  2626 39115 146228  3  5 88  3  0
 0  0      0 47797176 255300 603284    0    0     0    43  128  216  0  0 100  0  0
 0  0      0 47803244 255300 602580    0    0     0     0   78  124  0  0 100  0  0
 0  0      0 47789120 255336 603940    0    0     0  2676 14085 85798  3  3 92  1  0

powersaving

 0  0      0 47820780 255516 590292    0    0     0    31   81  126  0  0 100  0  0
 0  0      0 47823712 255516 589376    0    0     0     0  107  190  0  0 100  0  0
 0  0      0 47826608 255516 588060    0    0     0     0   76  130  0  0 100  0  0
 0  0      0 47811260 255632 602080    0    0     0  2678  106  200  0  0 100  0  0
 0  0      0 47812548 255632 601892    0    0     0     0   69  110  0  0 100  0  0
 0  0      0 47808284 255680 604400    0    0     0  2668 1588 3451  4  2 94  0  0
 0  0      0 47810300 255680 603624    0    0     0     0   77  124  0  0 100  0  0
20  3      0 47760764 255720 643744    0    0     1     0  948 2817  2  1 97  0  0
 0  0      0 47817828 255756 602400    0    0     1  2703  984  797  2  0 98  0  0
 0  0      0 47819548 255756 602532    0    0     0     0   93  158  0  0 100  0  0
 1  0      0 47819312 255792 603080    0    0     0  2661 1774 3348  4  2 94  0  0
 0  0      0 47821912 255800 602608    0    0     0     2   66  107  0  0 100  0  0

Invisible ink is pretty expensive stuff.

	-Mike

