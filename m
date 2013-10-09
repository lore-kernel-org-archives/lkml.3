Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757121Ab3JIKNP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 06:13:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53709 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752444Ab3JIKNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 06:13:14 -0400
Date: Wed, 9 Oct 2013 12:12:49 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V5 3/9] perf tools: workaround objdump difficulties with
 kcore
Message-ID: <20131009101249.GC1005@krava.redhat.com>
References: <1381221956-16699-1-git-send-email-adrian.hunter@intel.com>
 <1381221956-16699-4-git-send-email-adrian.hunter@intel.com>
 <20131008140236.GD1348@krava.redhat.com>
 <525506C5.3020101@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <525506C5.3020101@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 09, 2013 at 10:33:25AM +0300, Adrian Hunter wrote:
> On 08/10/13 17:02, Jiri Olsa wrote:
> > On Tue, Oct 08, 2013 at 11:45:50AM +0300, Adrian Hunter wrote:
> >> objdump fails to annotate module symbols when looking
> >> at kcore.  Workaround this by extracting object code
> >> from kcore and putting it in a temporary file for
> >> objdump to use instead.  The temporary file is created
> >> to look like kcore but contains only the function
> >> being disassembled.
> > 
> > Excited to ses this one, but looks like I'm hitting some
> > issue.  All annotation starts for me like this:
> > 
> >                                                                                                        ▒
> >        │              Disassembly of section load0:                                                            ▒
> >        │                                                                                                       ▒
> >        │              ffffffff815eee80 <load0>:                                                                ◆
> >   9.33 │ffffffff815eee80:   data32 data32 data32 xchg %ax,%ax                                                  
> > 
> > 
> > which does not seem right
> 
> Can you tell me the commits of the kernel and perf tools you
> were using, plus the commands and what symbol it was?

kernel: 3.9.10-100.fc17.x86_64
perf:   latest acme's perf/core (06de626 perf evlist: Fix perf_evlist__mmap_read event overflow )
        plus your V5 patches

commands:
  sudo ./perf record -e cycles:k -a 
  sudo ./perf report

---
Samples: 2K of event 'cycles:k', Event count (approx.): 445188286                                               
 14.73%          swapper  [kernel.kallsyms]   [k] intel_idle                                                   ◆
  3.19%                X  [kernel.kallsyms]   [k] smp_call_function_many                                       ▒
  1.58%                X  [kernel.kallsyms]   [k] i915_gem_write_fence__ipi                                    ▒
  1.58%          swapper  [kernel.kallsyms]   [k] iwl_trans_pcie_read32                                        ▒


annotation of 1st 4 symbols:

---
intel_idle  /proc/kcore                                                                                         
       │                                                                                                       ▒
       │                                                                                                       ▒
       │                                                                                                       ▒
       │     Disassembly of section load0:                                                                     ▒
       │                                                                                                       ▒
       │     ffffffff8135f490 <load0>:                                                                         ▒
  1.18 │       data32 data32 data32 xchg %ax,%ax                                                               ▒


---
smp_call_function_many  /proc/kcore                                                                             
       │                                                                                                       ◆
       │                                                                                                       ▒
       │                                                                                                       ▒
       │     Disassembly of section load0:                                                                     ▒
       │                                                                                                       ▒
       │     ffffffff810bc270 <load0>:                                                                         ▒
       │       data32 data32 data32 xchg %ax,%ax                                                               ▒

---
i915_gem_write_fence__ipi  /proc/kcore                                                                          
       │
       │
       │
       │    Disassembly of section load0:
       │
       │    ffffffffa0086630 <load0>:
       │      data32 data32 data32 xchg %ax,%ax

---
iwl_trans_pcie_read32  /proc/kcore                                                                              
       │
       │
       │
       │    Disassembly of section load0:
       │
       │    ffffffffa0414a50 <load0>:
       │      data32 data32 data32 xchg %ax,%ax


the rest of the instruction decode differs.. just the first
line is same for all

addresses seem ok:

[jolsa@krava perf]$ egrep 'ffffffff8135f490|ffffffff810bc270|ffffffffa0086630|ffffffffa0414a50' /proc/kallsyms 
ffffffff810bc270 T smp_call_function_many
ffffffff8135f490 t intel_idle
ffffffffa0414a50 t iwl_trans_pcie_read32        [iwlwifi]
ffffffffa0086630 t i915_gem_write_fence__ipi    [i915]

so.. the name of the section, name of the <function> plus the first
instruction decode seem wrong.. I can see that in every symbol I
annotate in the report and in annotate command as well.

jirka
