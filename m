Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932218Ab3LDKeL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 05:34:11 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:47654 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932167Ab3LDKeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 05:34:07 -0500
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Cc: michael@ellerman.id.au, mikey@neuling.org, sukadev@linux.vnet.ibm.com,
        eranian@google.com, acme@ghostprotocols.net, ak@linux.intel.com,
        mingo@kernel.org
Subject: [PATCH V4 00/10] perf: New conditional branch filter
Date: Wed,  4 Dec 2013 16:02:32 +0530
Message-Id: <1386153162-11225-1-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120410-2674-0000-0000-00000BC243C8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

		This patchset is the re-spin of the original branch stack sampling
patchset which introduced new PERF_SAMPLE_BRANCH_COND branch filter. This patchset
also enables SW based branch filtering support for book3s powerpc platforms which
have PMU HW backed branch stack sampling support. 

Summary of code changes in this patchset:

(1) Introduces a new PERF_SAMPLE_BRANCH_COND branch filter
(2) Add the "cond" branch filter options in the "perf record" tool
(3) Enable PERF_SAMPLE_BRANCH_COND in X86 platforms
(4) Enable PERF_SAMPLE_BRANCH_COND in POWER8 platform 
(5) Update the documentation regarding "perf record" tool
(6) Add some new powerpc instruction analysis functions in code-patching library
(7) Enable SW based branch filter support for powerpc book3s
(8) Changed BHRB configuration in POWER8 to accommodate SW branch filters 

With this new SW enablement, the branch filter support for book3s platforms have
been extended to include all these combinations discussed below with a sample test
application program (included here).

Changes in V2
=============
(1) Enabled PPC64 SW branch filtering support
(2) Incorporated changes required for all previous comments

Changes in V3
=============
(1) Split the SW branch filter enablement into multiple patches
(2) Added PMU neutral SW branch filtering code, PMU specific HW branch filtering code
(3) Added new instruction analysis functionality into powerpc code-patching library
(4) Changed name for some of the functions
(5) Fixed couple of spelling mistakes
(6) Changed code documentation in multiple places

Changes in V4
=============
(1) Changed the commit message for patch (01/10)
(2) Changed the patch (02/10) to accommodate review comments from Michael Ellerman
(3) Rebased the patchset against latest Linus's tree

PMU HW branch filters
=====================
(1) perf record -j any_call -e branch-misses:u ./cprog
# Overhead  Command  Source Shared Object          Source Symbol  Target Shared Object             Target Symbol
# ........  .......  ....................  .....................  ....................  ........................
#
     7.00%    cprog  cprog                 [.] sw_3_1             cprog                 [.] sw_3_1_2            
     6.99%    cprog  cprog                 [.] hw_1_1             cprog                 [.] symbol1             
     6.52%    cprog  cprog                 [.] sw_3_1             cprog                 [.] success_3_1_2       
     5.41%    cprog  cprog                 [.] sw_3_1             cprog                 [.] sw_3_1_3            
     5.40%    cprog  cprog                 [.] hw_1_2             cprog                 [.] symbol2             
     5.40%    cprog  cprog                 [.] callme             cprog                 [.] hw_1_2              
     5.40%    cprog  cprog                 [.] sw_3_1             cprog                 [.] success_3_1_1       
     5.40%    cprog  cprog                 [.] callme             cprog                 [.] hw_1_1              
     5.39%    cprog  cprog                 [.] sw_3_1             cprog                 [.] sw_3_1_1            
     5.39%    cprog  cprog                 [.] sw_4_2             cprog                 [.] lr_addr             
     5.39%    cprog  cprog                 [.] callme             cprog                 [.] sw_4_2              
     5.37%    cprog  [unknown]             [.] 00000000           cprog                 [.] ctr_addr            
     4.30%    cprog  cprog                 [.] callme             cprog                 [.] hw_2_1              
     4.28%    cprog  cprog                 [.] callme             cprog                 [.] sw_3_1              
     3.82%    cprog  cprog                 [.] sw_3_1             cprog                 [.] success_3_1_3       
     3.81%    cprog  cprog                 [.] callme             cprog                 [.] hw_2_2              
     3.81%    cprog  cprog                 [.] callme             cprog                 [.] sw_3_2              
     2.71%    cprog  [unknown]             [.] 00000000           cprog                 [.] lr_addr             
     2.70%    cprog  cprog                 [.] main               cprog                 [.] callme              
     2.70%    cprog  cprog                 [.] sw_4_1             cprog                 [.] ctr_addr            
     2.70%    cprog  cprog                 [.] callme             cprog                 [.] sw_4_1              
     0.08%    cprog  [unknown]             [.] 0xf78676c4         [unknown]             [.] 0xf78522c0          
     0.02%    cprog  [unknown]             [k] 00000000           cprog                 [k] ctr_addr            
     0.01%    cprog  [kernel.kallsyms]     [.] .power_pmu_enable  [kernel.kallsyms]     [.] .power8_compute_mmcr
     0.00%    cprog  ld-2.11.2.so          [.] malloc             [unknown]             [.] 0xf786b380          
     0.00%    cprog  ld-2.11.2.so          [.] calloc             [unknown]             [.] 0xf786b390          
     0.00%    cprog  cprog                 [.] main               [unknown]             [.] 0x10000950          
     0.00%    cprog  [unknown]             [.] 00000000           [kernel.kallsyms]     [.] .power_pmu_enable  
    
(2) perf record -j cond -e branch-misses:u ./cprog

# Overhead  Command  Source Shared Object            Source Symbol  Target Shared Object            Target Symbol
# ........  .......  ....................  .......................  ....................  .......................
#
    27.73%    cprog  [unknown]             [.] 00000000             cprog                 [.] callme             
    13.03%    cprog  cprog                 [.] sw_3_1               cprog                 [.] sw_3_1             
     5.64%    cprog  [unknown]             [.] 00000000             cprog                 [.] main               
     5.62%    cprog  [unknown]             [.] 00000000             cprog                 [.] sw_4_2             
     5.46%    cprog  cprog                 [.] sw_4_2               cprog                 [.] lr_addr            
     5.40%    cprog  [unknown]             [.] 00000000             cprog                 [.] sw_4_1             
     3.72%    cprog  cprog                 [.] hw_2_1               cprog                 [.] callme             
     3.71%    cprog  cprog                 [.] main                 cprog                 [.] hw_1_1             
     3.71%    cprog  cprog                 [.] sw_3_1_2             cprog                 [.] sw_3_1             
     3.70%    cprog  cprog                 [.] sw_3_1_3             cprog                 [.] sw_3_1             
     3.70%    cprog  cprog                 [.] sw_4_1               cprog                 [.] ctr_addr           
     3.69%    cprog  cprog                 [.] hw_1_2               cprog                 [.] hw_1_2             
     3.69%    cprog  cprog                 [.] hw_2_2               cprog                 [.] callme             
     3.68%    cprog  cprog                 [.] sw_3_1_1             cprog                 [.] sw_3_1             
     1.93%    cprog  [unknown]             [.] 00000000             cprog                 [.] lr_addr            
     1.78%    cprog  [unknown]             [.] 00000000             cprog                 [.] hw_1_2             
     1.78%    cprog  [unknown]             [.] 00000000             cprog                 [.] sw_3_1             
     1.76%    cprog  [unknown]             [.] 00000000             cprog                 [.] hw_1_1             
     0.12%    cprog  [unknown]             [.] 0xf7bb25dc           [unknown]             [.] 0xf7bb27e4         
     0.07%    cprog  [unknown]             [k] 00000000             cprog                 [k] callme             
     0.07%    cprog  [unknown]             [k] 00000000             cprog                 [k] sw_4_1             
     0.00%    cprog  libc-2.11.2.so        [.] _IO_file_doallocate  libc-2.11.2.so        [.] _IO_file_doallocate
     0.00%    cprog  libc-2.11.2.so        [.] _IO_file_doallocate  libc-2.11.2.so        [.] isatty             
     0.00%    cprog  [unknown]             [.] 00000000             libc-2.11.2.so        [.] _IO_file_doallocate

SW based branch filters
=======================
(3) perf record -j any_ret -e branch-misses:u ./cprog 

# Overhead  Command  Source Shared Object         Source Symbol  Target Shared Object          Target Symbol
# ........  .......  ....................  ....................  ....................  .....................
#
    15.37%    cprog  [unknown]             [.] 00000000          cprog                 [.] sw_3_1           
     6.46%    cprog  cprog                 [.] success_3_1_3     cprog                 [.] sw_3_1           
     6.45%    cprog  cprog                 [.] symbol1           cprog                 [.] hw_1_1           
     6.41%    cprog  [unknown]             [.] 00000000          cprog                 [.] callme           
     6.39%    cprog  cprog                 [.] ctr_addr          cprog                 [.] sw_4_1           
     6.37%    cprog  cprog                 [.] symbol2           cprog                 [.] hw_1_2           
     6.36%    cprog  cprog                 [.] sw_4_2            cprog                 [.] callme           
     6.35%    cprog  cprog                 [.] lr_addr           cprog                 [.] sw_4_2           
     3.97%    cprog  cprog                 [.] back1             cprog                 [.] callme           
     3.93%    cprog  cprog                 [.] sw_3_1_2          cprog                 [.] sw_3_1           
     3.93%    cprog  cprog                 [.] sw_3_1            cprog                 [.] callme           
     3.86%    cprog  cprog                 [.] sw_3_1_3          cprog                 [.] sw_3_1           
     3.84%    cprog  cprog                 [.] sw_3_1_1          cprog                 [.] sw_3_1           
     2.54%    cprog  cprog                 [.] success_3_1_1     cprog                 [.] sw_3_1           
     2.54%    cprog  cprog                 [.] sw_4_1            cprog                 [.] callme           
     2.54%    cprog  cprog                 [.] hw_1_1            cprog                 [.] callme           
     2.53%    cprog  cprog                 [.] sw_3_2            cprog                 [.] callme           
     2.52%    cprog  cprog                 [.] callme            cprog                 [.] main             
     2.51%    cprog  cprog                 [.] hw_1_2            cprog                 [.] callme           
     2.51%    cprog  cprog                 [.] back2             cprog                 [.] callme           
     2.51%    cprog  cprog                 [.] success_3_1_2     cprog                 [.] sw_3_1           
     0.07%    cprog  [unknown]             [k] 00000000          cprog                 [k] callme           
     0.02%    cprog  [unknown]             [.] 00000000          [unknown]             [.] 0xf7e5c004       
     0.01%    cprog  libc-2.11.2.so        [.] __errno_location  libc-2.11.2.so        [.] vfprintf         
     0.01%    cprog  [unknown]             [.] 00000000          libc-2.11.2.so        [.] _IO_file_overflow

(4) perf record -j ind_call  -e branch-misses:u ./cprog

# Overhead  Command  Source Shared Object        Source Symbol  Target Shared Object          Target Symbol
# ........  .......  ....................  ...................  ....................  .....................
#
    48.04%    cprog  [unknown]             [.] 00000000         cprog                 [.] sw_3_1           
    19.96%    cprog  cprog                 [.] sw_4_2           cprog                 [.] lr_addr          
    19.69%    cprog  [unknown]             [.] 00000000         cprog                 [.] callme           
    12.04%    cprog  cprog                 [.] sw_4_1           cprog                 [.] ctr_addr         
     0.18%    cprog  [unknown]             [k] 00000000         cprog                 [k] callme           
     0.02%    cprog  libc-2.11.2.so        [.] _IO_file_xsputn  libc-2.11.2.so        [.] _IO_file_overflow
     0.02%    cprog  [unknown]             [.] 00000000         libc-2.11.2.so        [.] _IO_file_xsputn  
     0.02%    cprog  [unknown]             [.] 00000000         ld-2.11.2.so          [.] malloc           
     0.02%    cprog  [unknown]             [k] 00000000         cprog                 [k] sw_3_1           

(5) perf record -j any_call,any_ret -e branch-misses:u ./cprog

# Overhead  Command  Source Shared Object            Source Symbol  Target Shared Object            Target Symbol
# ........  .......  ....................  .......................  ....................  .......................
#
    10.36%    cprog  [unknown]             [.] 00000000             cprog                 [.] sw_3_1             
     4.18%    cprog  cprog                 [.] symbol1              cprog                 [.] hw_1_1             
     4.18%    cprog  cprog                 [.] success_3_1_3        cprog                 [.] sw_3_1             
     4.17%    cprog  cprog                 [.] sw_4_2               cprog                 [.] lr_addr            
     4.16%    cprog  cprog                 [.] sw_4_2               cprog                 [.] callme             
     4.15%    cprog  cprog                 [.] ctr_addr             cprog                 [.] sw_4_1             
     4.15%    cprog  cprog                 [.] lr_addr              cprog                 [.] sw_4_2             
     4.14%    cprog  cprog                 [.] symbol2              cprog                 [.] hw_1_2             
     4.14%    cprog  [unknown]             [.] 00000000             cprog                 [.] callme             
     2.15%    cprog  cprog                 [.] sw_3_1               cprog                 [.] callme             
     2.14%    cprog  cprog                 [.] hw_1_1               cprog                 [.] symbol1            
     2.14%    cprog  cprog                 [.] callme               cprog                 [.] hw_1_1             
     2.14%    cprog  cprog                 [.] callme               cprog                 [.] sw_4_2             
     2.13%    cprog  cprog                 [.] back1                cprog                 [.] callme             
     2.12%    cprog  cprog                 [.] sw_3_1_2             cprog                 [.] sw_3_1             
     2.12%    cprog  cprog                 [.] sw_3_1               cprog                 [.] sw_3_1_2           
     2.11%    cprog  cprog                 [.] sw_3_1_3             cprog                 [.] sw_3_1             
     2.11%    cprog  cprog                 [.] sw_3_1               cprog                 [.] sw_3_1_3           
     2.11%    cprog  cprog                 [.] sw_4_1               cprog                 [.] ctr_addr           
     2.10%    cprog  cprog                 [.] hw_1_2               cprog                 [.] symbol2            
     2.10%    cprog  cprog                 [.] sw_3_1_1             cprog                 [.] sw_3_1             
     2.10%    cprog  cprog                 [.] sw_3_1               cprog                 [.] sw_3_1_1           
     2.10%    cprog  cprog                 [.] callme               cprog                 [.] hw_1_2             
     2.10%    cprog  cprog                 [.] callme               cprog                 [.] sw_3_1             
     2.05%    cprog  cprog                 [.] success_3_1_1        cprog                 [.] sw_3_1             
     2.05%    cprog  cprog                 [.] sw_3_1               cprog                 [.] success_3_1_1      
     2.05%    cprog  cprog                 [.] success_3_1_2        cprog                 [.] sw_3_1             
     2.05%    cprog  cprog                 [.] sw_3_1               cprog                 [.] success_3_1_2      
     2.04%    cprog  cprog                 [.] hw_1_1               cprog                 [.] callme             
     2.04%    cprog  cprog                 [.] back2                cprog                 [.] callme             
     2.04%    cprog  cprog                 [.] sw_4_1               cprog                 [.] callme             
     2.04%    cprog  cprog                 [.] callme               cprog                 [.] main               
     2.04%    cprog  cprog                 [.] hw_1_2               cprog                 [.] callme             
     2.04%    cprog  cprog                 [.] sw_3_2               cprog                 [.] callme             
     2.04%    cprog  cprog                 [.] callme               cprog                 [.] sw_3_2             
     2.03%    cprog  cprog                 [.] sw_3_1               cprog                 [.] success_3_1_3      
     0.03%    cprog  [unknown]             [k] 00000000             cprog                 [k] callme             
     0.01%    cprog  [unknown]             [.] 0xf7e79bb0           [unknown]             [.] 0xf7e64088         
     0.00%    cprog  libc-2.11.2.so        [.] _IO_file_doallocate  libc-2.11.2.so        [.] mmap               
     0.00%    cprog  libc-2.11.2.so        [.] mmap                 libc-2.11.2.so        [.] _IO_file_doallocate
     0.00%    cprog  [unknown]             [.] 0xf7e7589c           libc-2.11.2.so        [.] printf             
     0.00%    cprog  [unknown]             [k] 00000000             cprog                 [k] sw_3_1          

(6) perf record -j any_call,ind_call -e branch-misses:u ./cprog

# Overhead  Command  Source Shared Object   Source Symbol  Target Shared Object      Target Symbol
# ........  .......  ....................  ..............  ....................  .................
#
    23.09%    cprog  [unknown]             [.] 00000000    cprog                 [.] sw_3_1       
     8.99%    cprog  cprog                 [.] sw_4_2      cprog                 [.] lr_addr      
     8.92%    cprog  [unknown]             [.] 00000000    cprog                 [.] callme       
     5.18%    cprog  cprog                 [.] sw_3_1      cprog                 [.] success_3_1_2
     5.16%    cprog  cprog                 [.] sw_3_1      cprog                 [.] success_3_1_1
     5.16%    cprog  cprog                 [.] callme      cprog                 [.] sw_3_2       
     5.12%    cprog  cprog                 [.] sw_3_1      cprog                 [.] success_3_1_3
     3.85%    cprog  cprog                 [.] sw_3_1      cprog                 [.] sw_3_1_1     
     3.85%    cprog  cprog                 [.] callme      cprog                 [.] sw_3_1       
     3.84%    cprog  cprog                 [.] sw_4_1      cprog                 [.] ctr_addr     
     3.82%    cprog  cprog                 [.] hw_1_1      cprog                 [.] symbol1      
     3.82%    cprog  cprog                 [.] sw_3_1      cprog                 [.] sw_3_1_2     
     3.82%    cprog  cprog                 [.] sw_3_1      cprog                 [.] sw_3_1_3     
     3.82%    cprog  cprog                 [.] callme      cprog                 [.] hw_1_1       
     3.81%    cprog  cprog                 [.] hw_1_2      cprog                 [.] symbol2      
     3.81%    cprog  cprog                 [.] callme      cprog                 [.] hw_1_2       
     3.81%    cprog  cprog                 [.] callme      cprog                 [.] sw_4_2       
     0.05%    cprog  [unknown]             [k] 00000000    cprog                 [k] callme       
     0.03%    cprog  [unknown]             [.] 0xf7f7232c  [unknown]             [.] 0xf7f72334   
     0.01%    cprog  ld-2.11.2.so          [.] malloc      [unknown]             [.] 0xf7f8b380   
     0.01%    cprog  cprog                 [.] main        [unknown]             [.] 0x10000950   
     0.01%    cprog  [unknown]             [.] 00000000    ld-2.11.2.so          [.] malloc       
     0.01%    cprog  [unknown]             [.] 00000000    cprog                 [.] main         

(7) perf record -j cond,any_ret -e branch-misses:u ./cprog

# Overhead  Command  Source Shared Object          Source Symbol  Target Shared Object          Target Symbol
# ........  .......  ....................  .....................  ....................  .....................
#
    12.18%    cprog  [unknown]             [.] 00000000           cprog                 [.] sw_3_1           
     4.90%    cprog  cprog                 [.] sw_4_2             cprog                 [.] lr_addr          
     4.88%    cprog  [unknown]             [.] 00000000           cprog                 [.] callme           
     4.88%    cprog  cprog                 [.] lr_addr            cprog                 [.] sw_4_2           
     4.88%    cprog  cprog                 [.] sw_4_2             cprog                 [.] callme           
     4.86%    cprog  cprog                 [.] symbol1            cprog                 [.] hw_1_1           
     4.86%    cprog  cprog                 [.] success_3_1_3      cprog                 [.] sw_3_1           
     4.85%    cprog  cprog                 [.] symbol2            cprog                 [.] hw_1_2           
     4.85%    cprog  cprog                 [.] ctr_addr           cprog                 [.] sw_4_1           
     2.47%    cprog  cprog                 [.] sw_3_1_3           cprog                 [.] sw_3_1           
     2.46%    cprog  cprog                 [.] back1              cprog                 [.] callme           
     2.45%    cprog  cprog                 [.] hw_1_1             cprog                 [.] callme           
     2.45%    cprog  cprog                 [.] hw_2_1             cprog                 [.] address1         
     2.44%    cprog  cprog                 [.] hw_1_2             cprog                 [.] symbol2          
     2.44%    cprog  cprog                 [.] sw_3_1_1           cprog                 [.] sw_3_1           
     2.44%    cprog  cprog                 [.] sw_3_2             cprog                 [.] callme           
     2.44%    cprog  cprog                 [.] success_3_1_1      cprog                 [.] sw_3_1           
     2.44%    cprog  cprog                 [.] sw_3_1             cprog                 [.] success_3_1_1    
     2.44%    cprog  cprog                 [.] sw_3_1             cprog                 [.] success_3_1_3    
     2.43%    cprog  cprog                 [.] callme             cprog                 [.] main             
     2.43%    cprog  cprog                 [.] hw_2_2             cprog                 [.] address2         
     2.43%    cprog  cprog                 [.] sw_3_1_2           cprog                 [.] sw_3_1           
     2.43%    cprog  cprog                 [.] success_3_1_2      cprog                 [.] sw_3_1           
     2.43%    cprog  cprog                 [.] sw_3_1             cprog                 [.] success_3_1_2    
     2.43%    cprog  cprog                 [.] sw_4_1             cprog                 [.] callme           
     2.42%    cprog  cprog                 [.] sw_3_1             cprog                 [.] callme           
     2.42%    cprog  cprog                 [.] sw_4_1             cprog                 [.] ctr_addr         
     2.42%    cprog  cprog                 [.] back2              cprog                 [.] callme           
     2.40%    cprog  cprog                 [.] hw_1_2             cprog                 [.] callme           
     0.10%    cprog  [unknown]             [.] 0xf78923e0         [unknown]             [.] 0xf78923c0       
     0.03%    cprog  [unknown]             [k] 00000000           cprog                 [k] callme           
     0.01%    cprog  [unknown]             [k] 00000000           cprog                 [k] sw_3_1           
     0.01%    cprog  libc-2.11.2.so        [.] vfprintf           libc-2.11.2.so        [.] vfprintf         
     0.01%    cprog  libc-2.11.2.so        [.] _IO_file_overflow  [unknown]             [.] 0x0fee0100       
     0.01%    cprog  libc-2.11.2.so        [.] strchrnul          libc-2.11.2.so        [.] vfprintf         
     0.01%    cprog  libc-2.11.2.so        [.] strchrnul          libc-2.11.2.so        [.] strchrnul        
     0.01%    cprog  [unknown]             [.] 00000000           libc-2.11.2.so        [.] _IO_file_overflow


(8) perf record -j cond,ind_call -e branch-misses:u ./cprog

# Overhead  Command  Source Shared Object   Source Symbol  Target Shared Object        Target Symbol
# ........  .......  ....................  ..............  ....................  ...................
#
    26.21%    cprog  [unknown]             [.] 00000000    cprog                 [.] sw_3_1         
    10.50%    cprog  cprog                 [.] sw_4_2      cprog                 [.] lr_addr        
    10.38%    cprog  [unknown]             [.] 00000000    cprog                 [.] callme         
     5.31%    cprog  cprog                 [.] sw_3_1_2    cprog                 [.] sw_3_1         
     5.30%    cprog  cprog                 [.] sw_3_1_1    cprog                 [.] sw_3_1         
     5.27%    cprog  cprog                 [.] sw_3_1      cprog                 [.] success_3_1_2  
     5.26%    cprog  cprog                 [.] hw_2_2      cprog                 [.] address2       
     5.25%    cprog  cprog                 [.] hw_1_2      cprog                 [.] symbol2        
     5.25%    cprog  cprog                 [.] sw_3_1      cprog                 [.] success_3_1_3  
     5.24%    cprog  cprog                 [.] hw_2_1      cprog                 [.] address1       
     5.23%    cprog  cprog                 [.] sw_4_1      cprog                 [.] ctr_addr       
     5.20%    cprog  cprog                 [.] sw_3_1_3    cprog                 [.] sw_3_1         
     5.19%    cprog  cprog                 [.] sw_3_1      cprog                 [.] success_3_1_1  
     0.24%    cprog  [unknown]             [.] 0xf7cf23e0  [unknown]             [.] 0xf7cf23c0     
     0.11%    cprog  [unknown]             [k] 00000000    cprog                 [k] callme         
     0.01%    cprog  libc-2.11.2.so        [.] vfprintf    libc-2.11.2.so        [.] vfprintf       
     0.01%    cprog  libc-2.11.2.so        [.] vfprintf    libc-2.11.2.so        [.] _IO_file_xsputn
     0.01%    cprog  [unknown]             [.] 00000000    libc-2.11.2.so        [.] vfprintf       
     0.01%    cprog  [unknown]             [k] 00000000    cprog                 [k] sw_3_1         

(9) perf record -j any_call,cond,any_ret -e branch-misses:u ./cprog

# Overhead  Command  Source Shared Object      Source Symbol  Target Shared Object          Target Symbol
# ........  .......  ....................  .................  ....................  .....................
#
     9.96%    cprog  [unknown]             [.] 00000000       cprog                 [.] sw_3_1           
     4.06%    cprog  cprog                 [.] sw_4_2         cprog                 [.] lr_addr          
     4.04%    cprog  cprog                 [.] lr_addr        cprog                 [.] sw_4_2           
     4.03%    cprog  cprog                 [.] symbol1        cprog                 [.] hw_1_1           
     4.02%    cprog  [unknown]             [.] 00000000       cprog                 [.] callme           
     3.96%    cprog  cprog                 [.] ctr_addr       cprog                 [.] sw_4_1           
     3.94%    cprog  cprog                 [.] symbol2        cprog                 [.] hw_1_2           
     3.94%    cprog  cprog                 [.] success_3_1_3  cprog                 [.] sw_3_1           
     3.93%    cprog  cprog                 [.] sw_4_2         cprog                 [.] callme           
     2.08%    cprog  cprog                 [.] sw_3_2         cprog                 [.] callme           
     2.08%    cprog  cprog                 [.] callme         cprog                 [.] sw_3_2           
     2.07%    cprog  cprog                 [.] hw_2_2         cprog                 [.] address2         
     2.07%    cprog  cprog                 [.] success_3_1_2  cprog                 [.] sw_3_1           
     2.07%    cprog  cprog                 [.] sw_3_1         cprog                 [.] success_3_1_2    
     2.07%    cprog  cprog                 [.] back2          cprog                 [.] callme           
     2.06%    cprog  cprog                 [.] hw_1_1         cprog                 [.] callme           
     1.99%    cprog  cprog                 [.] sw_4_1         cprog                 [.] ctr_addr         
     1.98%    cprog  cprog                 [.] sw_3_1_3       cprog                 [.] sw_3_1           
     1.98%    cprog  cprog                 [.] success_3_1_1  cprog                 [.] sw_3_1           
     1.98%    cprog  cprog                 [.] sw_3_1         cprog                 [.] sw_3_1_3         
     1.98%    cprog  cprog                 [.] sw_3_1         cprog                 [.] success_3_1_1    
     1.98%    cprog  cprog                 [.] callme         cprog                 [.] sw_4_2           
     1.98%    cprog  cprog                 [.] back1          cprog                 [.] callme           
     1.97%    cprog  cprog                 [.] hw_1_1         cprog                 [.] symbol1          
     1.97%    cprog  cprog                 [.] hw_2_1         cprog                 [.] address1         
     1.97%    cprog  cprog                 [.] sw_3_1_1       cprog                 [.] sw_3_1           
     1.97%    cprog  cprog                 [.] sw_3_1         cprog                 [.] sw_3_1_1         
     1.97%    cprog  cprog                 [.] sw_3_1         cprog                 [.] success_3_1_3    
     1.97%    cprog  cprog                 [.] callme         cprog                 [.] hw_1_1           
     1.97%    cprog  cprog                 [.] callme         cprog                 [.] sw_3_1           
     1.97%    cprog  cprog                 [.] hw_1_2         cprog                 [.] symbol2          
     1.97%    cprog  cprog                 [.] hw_1_2         cprog                 [.] callme           
     1.97%    cprog  cprog                 [.] sw_4_1         cprog                 [.] callme           
     1.97%    cprog  cprog                 [.] callme         cprog                 [.] main             
     1.97%    cprog  cprog                 [.] callme         cprog                 [.] hw_1_2           
     1.96%    cprog  cprog                 [.] sw_3_1         cprog                 [.] callme           
     1.96%    cprog  cprog                 [.] sw_3_1_2       cprog                 [.] sw_3_1           
     1.96%    cprog  cprog                 [.] sw_3_1         cprog                 [.] sw_3_1_2         
     0.12%    cprog  [unknown]             [.] 0xf7ab23e0     [unknown]             [.] 0xf7ab23c0       
     0.04%    cprog  [unknown]             [k] 00000000       cprog                 [k] callme           
     0.01%    cprog  [unknown]             [k] 00000000       cprog                 [k] sw_3_1           
     0.00%    cprog  libc-2.11.2.so        [.] vfprintf       libc-2.11.2.so        [.] vfprintf         
     0.00%    cprog  libc-2.11.2.so        [.] _IO_do_write   libc-2.11.2.so        [.] _IO_do_write     
     0.00%    cprog  libc-2.11.2.so        [.] _IO_do_write   libc-2.11.2.so        [.] _IO_file_overflow
     0.00%    cprog  libc-2.11.2.so        [.] strchrnul      libc-2.11.2.so        [.] vfprintf         
     0.00%    cprog  libc-2.11.2.so        [.] strchrnul      libc-2.11.2.so        [.] strchrnul        
     0.00%    cprog  cprog                 [.] callme         cprog                 [.] hw_2_2           
     0.00%    cprog  [unknown]             [.] 00000000       libc-2.11.2.so        [.] _IO_do_write     

(10) perf record -j any_call,cond,ind_call -e branch-misses:u ./cprog

# Overhead  Command  Source Shared Object          Source Symbol  Target Shared Object          Target Symbol
# ........  .......  ....................  .....................  ....................  .....................
#
    17.81%    cprog  [unknown]             [.] 00000000           cprog                 [.] sw_3_1           
     7.19%    cprog  cprog                 [.] sw_4_2             cprog                 [.] lr_addr          
     7.12%    cprog  [unknown]             [.] 00000000           cprog                 [.] callme           
     3.71%    cprog  cprog                 [.] sw_3_1             cprog                 [.] success_3_1_2    
     3.68%    cprog  cprog                 [.] callme             cprog                 [.] sw_3_2           
     3.67%    cprog  cprog                 [.] hw_2_2             cprog                 [.] address2         
     3.57%    cprog  cprog                 [.] hw_2_1             cprog                 [.] address1         
     3.55%    cprog  cprog                 [.] hw_1_1             cprog                 [.] symbol1          
     3.55%    cprog  cprog                 [.] sw_3_1             cprog                 [.] success_3_1_1    
     3.55%    cprog  cprog                 [.] callme             cprog                 [.] hw_1_1           
     3.54%    cprog  cprog                 [.] sw_3_1_1           cprog                 [.] sw_3_1           
     3.54%    cprog  cprog                 [.] sw_3_1             cprog                 [.] sw_3_1_1         
     3.54%    cprog  cprog                 [.] sw_4_1             cprog                 [.] ctr_addr         
     3.54%    cprog  cprog                 [.] callme             cprog                 [.] sw_3_1           
     3.52%    cprog  cprog                 [.] sw_3_1_3           cprog                 [.] sw_3_1           
     3.52%    cprog  cprog                 [.] sw_3_1             cprog                 [.] sw_3_1_3         
     3.52%    cprog  cprog                 [.] sw_3_1             cprog                 [.] success_3_1_3    
     3.52%    cprog  cprog                 [.] sw_3_1_2           cprog                 [.] sw_3_1           
     3.52%    cprog  cprog                 [.] sw_3_1             cprog                 [.] sw_3_1_2         
     3.51%    cprog  cprog                 [.] hw_1_2             cprog                 [.] symbol2          
     3.51%    cprog  cprog                 [.] callme             cprog                 [.] hw_1_2           
     3.49%    cprog  cprog                 [.] callme             cprog                 [.] sw_4_2           
     0.22%    cprog  [unknown]             [.] 0xf7ca23f4         [unknown]             [.] 0xf7ca25d0       
     0.05%    cprog  [unknown]             [k] 00000000           cprog                 [k] callme           
     0.01%    cprog  libc-2.11.2.so        [.] vfprintf           libc-2.11.2.so        [.] vfprintf         
     0.01%    cprog  libc-2.11.2.so        [.] vfprintf           libc-2.11.2.so        [.] strchrnul        
     0.01%    cprog  libc-2.11.2.so        [.] _IO_file_overflow  libc-2.11.2.so        [.] _IO_file_overflow
     0.01%    cprog  libc-2.11.2.so        [.] strchrnul          libc-2.11.2.so        [.] strchrnul        
     0.01%    cprog  [unknown]             [.] 00000000           libc-2.11.2.so        [.] _IO_file_overflow
     0.01%    cprog  [unknown]             [k] 00000000           cprog                 [k] sw_3_1        

(11) perf record -j any_call,cond,any_ret,ind_call -e branch-misses:u ./cprog

# Overhead  Command  Source Shared Object      Source Symbol  Target Shared Object        Target Symbol
# ........  .......  ....................  .................  ....................  ...................
#
     9.72%    cprog  [unknown]             [.] 00000000       cprog                 [.] sw_3_1         
     3.99%    cprog  cprog                 [.] ctr_addr       cprog                 [.] sw_4_1         
     3.98%    cprog  cprog                 [.] success_3_1_3  cprog                 [.] sw_3_1         
     3.98%    cprog  cprog                 [.] symbol1        cprog                 [.] hw_1_1         
     3.98%    cprog  cprog                 [.] symbol2        cprog                 [.] hw_1_2         
     3.98%    cprog  cprog                 [.] sw_4_2         cprog                 [.] lr_addr        
     3.98%    cprog  cprog                 [.] sw_4_2         cprog                 [.] callme         
     3.97%    cprog  cprog                 [.] lr_addr        cprog                 [.] sw_4_2         
     3.91%    cprog  [unknown]             [.] 00000000       cprog                 [.] callme         
     2.22%    cprog  cprog                 [.] sw_4_1         cprog                 [.] ctr_addr       
     2.22%    cprog  cprog                 [.] callme         cprog                 [.] sw_4_2         
     2.22%    cprog  cprog                 [.] hw_2_1         cprog                 [.] address1       
     2.22%    cprog  cprog                 [.] back1          cprog                 [.] callme         
     2.21%    cprog  cprog                 [.] hw_1_2         cprog                 [.] symbol2        
     2.21%    cprog  cprog                 [.] sw_3_1         cprog                 [.] callme         
     2.21%    cprog  cprog                 [.] callme         cprog                 [.] hw_1_2         
     2.21%    cprog  cprog                 [.] sw_3_1_1       cprog                 [.] sw_3_1         
     2.21%    cprog  cprog                 [.] sw_3_1_3       cprog                 [.] sw_3_1         
     2.21%    cprog  cprog                 [.] sw_3_1         cprog                 [.] sw_3_1_1       
     2.21%    cprog  cprog                 [.] sw_3_1         cprog                 [.] sw_3_1_3       
     2.21%    cprog  cprog                 [.] callme         cprog                 [.] sw_3_1         
     2.20%    cprog  cprog                 [.] hw_1_1         cprog                 [.] symbol1        
     2.20%    cprog  cprog                 [.] sw_3_1_2       cprog                 [.] sw_3_1         
     2.20%    cprog  cprog                 [.] sw_3_1         cprog                 [.] sw_3_1_2       
     2.20%    cprog  cprog                 [.] callme         cprog                 [.] hw_1_1         
     1.77%    cprog  cprog                 [.] hw_1_1         cprog                 [.] callme         
     1.77%    cprog  cprog                 [.] success_3_1_1  cprog                 [.] sw_3_1         
     1.77%    cprog  cprog                 [.] sw_3_1         cprog                 [.] success_3_1_1  
     1.77%    cprog  cprog                 [.] success_3_1_2  cprog                 [.] sw_3_1         
     1.77%    cprog  cprog                 [.] sw_3_1         cprog                 [.] success_3_1_2  
     1.77%    cprog  cprog                 [.] sw_3_1         cprog                 [.] success_3_1_3  
     1.76%    cprog  cprog                 [.] hw_1_2         cprog                 [.] callme         
     1.76%    cprog  cprog                 [.] sw_4_1         cprog                 [.] callme         
     1.76%    cprog  cprog                 [.] sw_3_2         cprog                 [.] callme         
     1.76%    cprog  cprog                 [.] callme         cprog                 [.] main           
     1.76%    cprog  cprog                 [.] callme         cprog                 [.] sw_3_2         
     1.75%    cprog  cprog                 [.] hw_2_2         cprog                 [.] address2       
     1.75%    cprog  cprog                 [.] back2          cprog                 [.] callme         
     0.13%    cprog  [unknown]             [.] 0xf7dd23e0     [unknown]             [.] 0xf7dd23c0     
     0.07%    cprog  [unknown]             [k] 00000000       cprog                 [k] callme         
     0.00%    cprog  libc-2.11.2.so        [.] vfprintf       libc-2.11.2.so        [.] vfprintf       
     0.00%    cprog  libc-2.11.2.so        [.] vfprintf       libc-2.11.2.so        [.] _IO_file_xsputn
     0.00%    cprog  [unknown]             [.] 00000000       libc-2.11.2.so        [.] vfprintf       

Test application program
========================
(1) Makefile:
--------------------------------------------
all: sample.o cprog of.cprog of.sample

sample.o: sample.s
        as -o sample.o sample.s
cprog: cprog.c sample.o
        gcc -o cprog cprog.c sample.o
of.sample: sample.o
        objdump -d sample.o > of.sample
of.cprog: cprog
        objdump -d cprog > of.cprog
clean:
        rm sample.o cprog of.sample of.cprog
---------------------------------------------
(2) cprog.c
---------------------------------------------
#include <stdio.h>
#define LOOP_COUNT 10000

extern void callme(void);

int main(int argc, char *argv[])
{
        int i;
        for(i = 0; i < LOOP_COUNT; i++)
                callme();

        printf("end");
        return 0;
}
---------------------------------------------
(3) sample.S
---------------------------------------------
# r25, r26, r27 will be used as first level, second level
# and third level stack for LR. Register r20, r21, r22, r23
# r24 will be used for general programming purpose.

.data

msg:
	.string "BHRB filter tests\n"
	len = . - msg
msg_1_1:
	.string "Test: hw_1_1\n"
	len_1_1 = 13
msg_1_2:
	.string "Test: hw_1_2\n"
	len_1_2 = 13
msg_2_1:
	.string "Test: hw_2_1\n"
	len_2_1 = 13
msg_2_2:
	.string "Test: hw_2_2\n"
	len_2_2 = 13
msg_3_1:
	.string "Test: sw_3_1\n"
	len_3_1 = 13
msg_3_1_1:
	.string "Test: sw_3_1_1\n"
	len_3_1_1 = 15
msg_3_1_2:
	.string "Test: sw_3_1_2\n"
	len_3_1_2 = 15
msg_3_1_3:
        .string "Test: sw_3_1_3\n"
        len_3_1_3 = 15
msg_3_2:
	.string "Test: sw_3_2\n"
	len_3_3 = 13
msg_4_1:
	.string "Test: sw_4_1\n"
	len_4_1 = 13
msg_4_2:
	.string "Test: sw_4_2\n"
	len_4_2 = 13

hw_3_1_1_passed:
	.string "\thw_3_1_1_passed\n\n"
	len_hw_3_1_1_passed = 18
hw_3_1_2_passed:
	.string "\thw_3_1_2_passed\n\n"
	len_hw_3_1_2_passed = 18
hw_3_1_3_passed:
	.string "\thw_3_1_3_passed\n\n"
	len_hw_3_1_3_passed = 18

hw_2_1_passed:
	.string "\thw_2_1_passed\n\n"
	len_hw_2_1_passed = 16

hw_2_2_passed:
	.string "\thw_2_2_passed\n\n"
	len_hw_2_2_passed = 16

hw_1_1_passed:
	.string "\thw_1_1_passed\n\n"
	len_hw_1_1_passed = 16

hw_1_2_passed:
	.string "\thw_1_2_passed\n\n"
	len_hw_1_2_passed = 16

hw_4_1_passed:
	.string "\thw_4_1_passed\n\n"
	len_hw_4_1_passed = 16

hw_4_2_passed:
	.string "\thw_4_2_passed\n\n"
	len_hw_4_2_passed = 16

msg_error:
	.string "\tError\n"
	len_error = 7
.text
	.global callme
	.global hw_1_1
	.global hw_1_2
	.global hw_2_1
	.global hw_2_2

# HW filter test symbols
symbol1:
	# Print "hw_1_1_passed"
	li      0, 4
	li      3, 1
	lis     4, hw_1_1_passed@ha
	addi    4, 4, hw_1_1_passed@l
	li      5, len_hw_1_1_passed
	sc

	blr				# PERF_SAMPLE_BRANCH_ANY_RET

hw_1_1:
        # Save LR - second level
        mflr 26

	# Print "hw_1_1 called"
	li      0, 4
	li      3, 1
	lis     4, msg_1_1@ha
	addi    4, 4, msg_1_1@l
	li      5, len_1_1
	sc

	bl symbol1			# PERF_SAMPLE_BRANCH_ANY_CALL

	# Restore LR
	mtlr 26
	blr				# PERF_SAMPLE_BRANCH_ANY_RET

symbol2:
        # Print "Symbol2 taken"
        li      0, 4
        li      3, 1
        lis     4, hw_1_2_passed@ha
        addi    4, 4, hw_1_2_passed@l
        li      5, len_hw_1_2_passed
        sc

	blr				# PERF_SAMPLE_BRANCH_ANY_RET
hw_1_2:
	# Save LR - second level
	mflr 26

        # Print "hw_1_2 called"
        li      0, 4
        li      3, 1
        lis     4, msg_1_2@ha
        addi    4, 4, msg_1_2@l
        li      5, len_1_2
        sc

	li 4,20
	cmpi 0,4,20
	bcl 12, 4*cr0+2, symbol2	# PERF_SAMPLE_BRANCH_ANY_CALL | PERF_SAMPLE_BRANCH_COND

	mtlr 26
	blr				# PERF_SAMPLE_BRANCH_ANY_RET

# HW filter test

address1: 
	# Print "hw_2_1_passed"
        li      0, 4
        li      3, 1
        lis     4, hw_2_1_passed@ha
        addi    4, 4, hw_2_1_passed@l
        li      5, len_hw_2_1_passed
        sc
	b  back1			# PERF_SAMPLE_BRANCH_ANY

hw_2_1:
	# Print "hw_2_1 called"
	li      0, 4
	li      3, 1
	lis     4, msg_2_1@ha
	addi    4, 4, msg_2_1@l
	li      5, len_2_1
	sc
	
	# Simple conditional branch (equal)
	li	20, 12
	cmpi	3, 20, 12
	bc	12, 4*cr3+2, address1	# PERF_SAMPLE_BRANCH_COND

back1:
	blr				# PERF_SAMPLE_BRANCH_ANY_RET

address2:
        # Print "hw_2_2_passed"
        li      0, 4
        li      3, 1
        lis     4, hw_2_2_passed@ha
        addi    4, 4, hw_2_2_passed@l
        li      5, len_hw_2_2_passed
        sc
        b  back2			# PERF_SAMPLE_BRANCH_ANY

hw_2_2:
        # Print "hw_2_2 called"
	li      0, 4
	li      3, 1
	lis     4, msg_2_2@ha
	addi    4, 4, msg_2_2@l
	li      5, len_2_2
	sc

	# Simple conditional branch (less than)
	li	20, 12
	cmpi	4, 20, 20
	bc	12, 4*cr4+0, address2	# PERF_SAMPLE_BRANCH_COND
back2:
	blr				# PERF_SAMPLE_BRANCH_ANY_RET

# SW filter test symbols
sw_3_1_1:
	# Print "Test: sw_3_1_1"
        li      0, 4
        li      3, 1
        lis     4, msg_3_1_1@ha
        addi    4, 4, msg_3_1_1@l
        li      5, len_3_1_1
        sc

	li	22,0
	# Test the condition and return
	li	21, 10
	cmpi	0, 21, 10
	bclr	12, 2			# PERF_SAMPLE_BRANCH_ANY_RET | PERF_SAMPLE_BRANCH_COND

	# Should not have come here
	li      0, 4
	li      3, 1
        lis     4, msg_error@ha
        addi    4, 4, msg_error@l
        li      5, len_error
        sc
	
	# Mark the error
	li 	22, 1
	
	# Safe fall back
	blr				# PERF_SAMPLE_BRANCH_ANY_RET

sw_3_1_2:
        # Print "Test: sw_3_1_2"
        li      0, 4
        li      3, 1
        lis     4, msg_3_1_2@ha
        addi    4, 4, msg_3_1_2@l
        li      5, len_3_1_2
        sc

	li	23, 0
	# Test the condition and return
	li	21, 10
	cmpi	0, 21, 20
	bclr	12, 0			# PERF_SAMPLE_BRANCH_ANY_RET | PERF_SAMPLE_BRANCH_COND
        
	# Should not have come here
	li      0, 4
	li      3, 1
        lis     4, msg_error@ha
        addi    4, 4, msg_error@l
        li      5, len_error
        sc

	# Mark the error
	li 	23, 1

	# Safe fall back
	blr				# PERF_SAMPLE_BRANCH_ANY_RET

sw_3_1_3:
	# Print "Test: sw_3_1_3"
        li      0, 4
        li      3, 1
        lis     4, msg_3_1_3@ha
        addi    4, 4, msg_3_1_3@l
        li      5, len_3_1_3
        sc

	li	24, 0
	# Test the condition and return
	li	21, 10
	cmpi	0, 21, 5
	bclr	12, 1			# PERF_SAMPLE_BRANCH_ANY_RET | PERF_SAMPLE_BRANCH_COND
	
	# Mark the error
	li 	24, 1

	# Should not have come here
	li      0, 4
	li      3, 1
        lis     4, msg_error@ha
        addi    4, 4, msg_error@l
        li      5, len_error
        sc

	# Safe fall back
	blr				# PERF_SAMPLE_BRANCH_ANY_RET

success_3_1_1:
	li      0, 4
	li      3, 1
        lis     4, hw_3_1_1_passed@ha
        addi    4, 4, hw_3_1_1_passed@l
        li      5, len_hw_3_1_1_passed
        sc
	blr

success_3_1_2:
	li      0, 4
	li      3, 1
        lis     4, hw_3_1_2_passed@ha
        addi    4, 4, hw_3_1_2_passed@l
        li      5, len_hw_3_1_2_passed
        sc
	blr

success_3_1_3:
	li      0, 4
	li      3, 1
        lis     4, hw_3_1_3_passed@ha
        addi    4, 4, hw_3_1_3_passed@l
        li      5, len_hw_3_1_3_passed
        sc
	blr

sw_3_1:
	# Save LR
	mflr 26

        # Print "Test: sw_3_1"
        li      0, 4
        li      3, 1
        lis     4, msg_3_1@ha
        addi    4, 4, msg_3_1@l
        li      5, len_3_1
        sc

	# Equal comparison condition
	bl sw_3_1_1			# PERF_SAMPLE_BRANCH_ANY_CALL
	cmpi	0, 22, 0
	bcl	12, 2, success_3_1_1	# PERF_SAMPLE_BRANCH_ANY_CALL | PERF_SAMPLE_BRANCH_COND

	# LT comparison condition
	bl sw_3_1_2			# PERF_SAMPLE_BRANCH_ANY_CALL
	cmpi	0, 23, 0
	bcl	12, 2, success_3_1_2	# PERF_SAMPLE_BRANCH_ANY_CALL | PERF_SAMPLE_BRANCH_COND

	# GT comparison condition
	bl sw_3_1_3			# PERF_SAMPLE_BRANCH_ANY_CALL
	cmpi	0, 24, 0
	bcl	12, 2, success_3_1_3	# PERF_SAMPLE_BRANCH_ANY_CALL | PERF_SAMPLE_BRANCH_COND

	mtlr 26
	blr				# PERF_SAMPLE_BRANCH_ANY_RET
sw_3_2:
	# Print "Test: sw_3_2"
	li      0, 4
	li      3, 1
	lis     4, msg_3_2@ha
	addi    4, 4, msg_3_2@l
	li      5, len_3_1
	sc

	# FIXME: Anything more here ?
	blr				# PERF_SAMPLE_BRANCH_ANY_RET

# Indirect call tests

# CTR
ctr_addr:
        # Print "bcctr taken"
        li      0, 4
        li      3, 1
        lis     4, hw_4_1_passed@ha
        addi    4, 4, hw_4_1_passed@l
        li      5, len_hw_4_1_passed
        sc

	blr				# PERF_SAMPLE_BRANCH_ANY_RET
sw_4_1:
	# Save LR
	mflr	26

	# Print "sw_4_1 called"
        li      0, 4
        li      3, 1
        lis     4, msg_4_1@ha
        addi    4, 4, msg_4_1@l
        li      5, len_4_1
        sc

	# Save address in CTR
	lis 	20, ctr_addr@ha
	addi	20, 20, ctr_addr@l
	mtctr   20


	# Compare and jump to CTR
	li 	21, 10
	cmpi	0, 21, 10
	bcctrl  12, 4*cr0+2		# PERF_SAMPLE_BRANCH_IND_CALL

	mtlr	26
	blr				# PERF_SAMPLE_BRANCH_ANY_RET
# LR
lr_addr:
	# Print "bclrl taken"
	li      0, 4
	li      3, 1
	lis     4, hw_4_2_passed@ha
	addi    4, 4, hw_4_2_passed@l
	li      5, len_hw_4_2_passed
	sc

	blr				# PERF_SAMPLE_BRANCH_ANY_RET

sw_4_2:
	# Save LR
	mflr	26

        # Print "Test: sw_4_2"
        li      0, 4
        li      3, 1
        lis     4, msg_4_2@ha
        addi    4, 4, msg_4_2@l
        li      5, len_4_2
        sc

	# Save address in LR
	lis 	20, lr_addr@ha
	addi	20, 20, lr_addr@l
	mtlr	20


	# Compare and jump to CTR
	li 	21, 10
	cmpi	0, 21, 10
	bclrl   12, 4*cr0+2		# PERF_SAMPLE_BRANCH_IND_CALL

	# Restore LR
	mtlr	26	
	blr				# PERF_SAMPLE_BRANCH_ANY_RET

callme:
	# Save LR
	mflr	25

	# Print "Branch filter Test"
	li	0, 4
	li	3, 1
	lis 	4, msg@ha
	addi	4, 4, msg@l
	li	5, len
	sc

	# PERF_SAMPLE_BRANCH_ANY_CALL
	bl hw_1_1			# PERF_SAMPLE_BRANCH_ANY_CALL
	bl hw_1_2			# PERF_SAMPLE_BRANCH_ANY_CALL
	# PERF_SAMPLE_BRANCH_COND
	bl hw_2_1			# PERF_SAMPLE_BRANCH_ANY_CALL
	bl hw_2_2			# PERF_SAMPLE_BRANCH_ANY_CALL

	# PERF_SAMPLE_BRANCH_ANY_RET
	bl sw_3_1			# PERF_SAMPLE_BRANCH_ANY_CALL
	bl sw_3_2			# PERF_SAMPLE_BRANCH_ANY_CALL
	# PERF_SAMPLE_BRANCH_IND_CALL
	bl sw_4_1			# PERF_SAMPLE_BRANCH_ANY_CALL
	bl sw_4_2			# PERF_SAMPLE_BRANCH_ANY_CALL

	# Restore LR
	mtlr 25
	blr				# PERF_SAMPLE_BRANCH_ANY_RET
--------------------------------------------------------------------

Anshuman Khandual (10):
  perf: Add PERF_SAMPLE_BRANCH_COND
  powerpc, perf: Enable conditional branch filter for POWER8
  perf, tool: Conditional branch filter 'cond' added to perf record
  x86, perf: Add conditional branch filtering support
  perf, documentation: Description for conditional branch filter
  powerpc, perf: Change the name of HW PMU branch filter tracking
    variable
  powerpc, lib: Add new branch instruction analysis support functions
  powerpc, perf: Enable SW filtering in branch stack sampling framework
  power8, perf: Change BHRB branch filter configuration
  powerpc, perf: Cleanup SW branch filter list look up

 arch/powerpc/include/asm/code-patching.h     |  30 ++++
 arch/powerpc/include/asm/perf_event_server.h |   6 +-
 arch/powerpc/lib/code-patching.c             |  54 +++++-
 arch/powerpc/perf/core-book3s.c              | 260 +++++++++++++++++++++++++--
 arch/powerpc/perf/power8-pmu.c               |  75 ++++++--
 arch/x86/kernel/cpu/perf_event_intel_lbr.c   |   5 +
 include/uapi/linux/perf_event.h              |   3 +-
 tools/perf/Documentation/perf-record.txt     |   3 +-
 tools/perf/builtin-record.c                  |   1 +
 9 files changed, 404 insertions(+), 33 deletions(-)

-- 
1.7.11.7

