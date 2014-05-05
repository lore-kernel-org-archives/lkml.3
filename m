Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041AbaEEJNC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 05:13:02 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:45842 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755752AbaEEJLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 05:11:04 -0400
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Cc: michael@ellerman.id.au, mikey@neuling.org, ak@linux.intel.com,
        eranian@google.com, acme@ghostprotocols.net,
        sukadev@linux.vnet.ibm.com, mingo@kernel.org
Subject: [V6 00/11] perf: New conditional branch filter
Date: Mon,  5 May 2014 14:39:02 +0530
Message-Id: <1399280953-31442-1-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050509-3864-0000-0000-00000E07EDB7
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

Changes in V5
=============
(1) Added a precursor patch to cleanup the indentation problem in power_pmu_bhrb_read
(2) Added a precursor patch to re-arrange P8 PMU BHRB filter config which improved the clarity
(3) Merged the previous 10th patch into the 8th patch
(4) Moved SW based branch analysis code from core perf into code-patching library as suggested by Michael
(5) Simplified the logic in branch analysis library
(6) Fixed some ambiguities in documentation at various places
(7) Added some more in-code documentation blocks at various places
(8) Renamed some local variable and function names
(9) Fixed some indentation and white space errors in the code
(10) Implemented almost all the review comments and suggestions made by Michael Ellerman on V4 patchset
(11) Enabled privilege mode SW branch filter
(12) Simplified and generalized the SW implemented conditional branch filter
(13) PERF_SAMPLE_BRANCH_COND filter is now supported only through SW implementation
(14) Adjusted other patches to deal with the above changes

Changes in V6
=============
(1) Rebased the patchset against the master
(2) Added "Reviewed-by: Andi Kleen" in the first four patches in the series which changes the
    generic or X86 perf code. [https://lkml.org/lkml/2014/4/7/130]

HW implemented branch filters
=============================

(1) perf record -j any_call -e branch-misses:u ./cprog

# Overhead  Command  Source Shared Object            Source Symbol  Target Shared Object         Target Symbol
# ........  .......  ....................  .......................  ....................  ....................
#
     7.85%    cprog  cprog                 [.] sw_3_1               cprog                 [.] success_3_1_2   
     5.66%    cprog  cprog                 [.] sw_3_1               cprog                 [.] sw_3_1_2        
     5.65%    cprog  cprog                 [.] hw_1_1               cprog                 [.] symbol1         
     5.42%    cprog  cprog                 [.] sw_3_1               cprog                 [.] sw_3_1_3        
     5.40%    cprog  cprog                 [.] callme               cprog                 [.] hw_1_1          
     5.40%    cprog  cprog                 [.] sw_3_1               cprog                 [.] success_3_1_1   
     5.40%    cprog  cprog                 [.] sw_3_1               cprog                 [.] sw_3_1_1        
     5.39%    cprog  cprog                 [.] sw_4_2               cprog                 [.] lr_addr         
     5.39%    cprog  cprog                 [.] callme               cprog                 [.] sw_4_2          
     5.39%    cprog  [unknown]             [.] 00000000             cprog                 [.] ctr_addr        
     5.38%    cprog  cprog                 [.] hw_1_2               cprog                 [.] symbol2         
     5.38%    cprog  cprog                 [.] callme               cprog                 [.] hw_1_2          
     5.16%    cprog  cprog                 [.] sw_3_1               cprog                 [.] success_3_1_3   
     5.15%    cprog  cprog                 [.] callme               cprog                 [.] sw_3_2          
     5.14%    cprog  cprog                 [.] callme               cprog                 [.] hw_2_2          
     2.96%    cprog  cprog                 [.] callme               cprog                 [.] sw_3_1          
     2.94%    cprog  cprog                 [.] callme               cprog                 [.] hw_2_1          
     2.71%    cprog  cprog                 [.] main                 cprog                 [.] callme          
     2.71%    cprog  [unknown]             [.] 00000000             cprog                 [.] lr_addr         
     2.70%    cprog  cprog                 [.] sw_4_1               cprog                 [.] ctr_addr        
     2.70%    cprog  cprog                 [.] callme               cprog                 [.] sw_4_1          
     0.09%    cprog  [unknown]             [.] 0xf7ad76c4           [unknown]             [.] 0xf7ac22c0      
     0.00%    cprog  libc-2.11.2.so        [.] vfprintf             libc-2.11.2.so        [.] __errno_location
     0.00%    cprog  libc-2.11.2.so        [.] printf               libc-2.11.2.so        [.] vfprintf        
     0.00%    cprog  libc-2.11.2.so        [.] _IO_file_doallocate  libc-2.11.2.so        [.] isatty          
     0.00%    cprog  libc-2.11.2.so        [.] _IO_file_doallocate  libc-2.11.2.so        [.] mmap            
     0.00%    cprog  libc-2.11.2.so        [.] isatty               libc-2.11.2.so        [.] tcgetattr       
     0.00%    cprog  cprog                 [.] main                 [unknown]             [.] 0x10000950      
     0.00%    cprog  [unknown]             [.] 00000000             libc-2.11.2.so        [.] _IO_file_stat   
     0.00%    cprog  [unknown]             [.] 0xf7acfca4           cprog                 [.] _fini           
     0.00%    cprog  [unknown]             [k] 00000000             cprog                 [k] ctr_addr        
     0.00%    cprog  [unknown]             [k] 00000000             cprog                 [k] lr_addr         

SW implemented branch filters
=============================

(2) perf record -j cond -e branch-misses:u ./cprog

# Overhead  Command  Source Shared Object           Source Symbol  Target Shared Object           Target Symbol
# ........  .......  ....................  ......................  ....................  ......................
#
    25.82%    cprog  [unknown]             [.] 00000000            cprog                 [.] sw_3_1            
    12.66%    cprog  cprog                 [.] sw_4_2              cprog                 [.] lr_addr           
    12.63%    cprog  [unknown]             [.] 00000000            cprog                 [.] callme            
     9.42%    cprog  cprog                 [.] hw_2_2              cprog                 [.] address2          
     9.39%    cprog  cprog                 [.] sw_3_1              cprog                 [.] success_3_1_2     
     4.91%    cprog  cprog                 [.] sw_3_1              cprog                 [.] success_3_1_1     
     4.91%    cprog  cprog                 [.] sw_3_1              cprog                 [.] success_3_1_3     
     3.35%    cprog  cprog                 [.] sw_3_1_3            cprog                 [.] sw_3_1            
     3.34%    cprog  cprog                 [.] sw_3_1_1            cprog                 [.] sw_3_1            
     3.31%    cprog  cprog                 [.] hw_1_2              cprog                 [.] symbol2           
     3.31%    cprog  cprog                 [.] sw_4_1              cprog                 [.] ctr_addr          
     3.29%    cprog  cprog                 [.] hw_2_1              cprog                 [.] address1          
     3.27%    cprog  cprog                 [.] sw_3_1_2            cprog                 [.] sw_3_1            
     0.32%    cprog  [unknown]             [.] 0xf7c62328          [unknown]             [.] 0xf7c62320        
     0.01%    cprog  libc-2.11.2.so        [.] vfprintf            libc-2.11.2.so        [.] vfprintf          
     0.01%    cprog  libc-2.11.2.so        [.] _IO_file_xsputn     libc-2.11.2.so        [.] _IO_file_xsputn   
     0.01%    cprog  libc-2.11.2.so        [.] _IO_default_xsputn  libc-2.11.2.so        [.] _IO_default_xsputn
     0.01%    cprog  libc-2.11.2.so        [.] strchrnul           libc-2.11.2.so        [.] strchrnul         
     0.01%    cprog  [unknown]             [.] 00000000            libc-2.11.2.so        [.] _IO_file_xsputn   
     0.01%    cprog  [unknown]             [k] 00000000            cprog                 [k] callme            


(3) perf record -j any_ret -e branch-misses:u ./cprog

# Overhead  Command  Source Shared Object          Source Symbol  Target Shared Object          Target Symbol
# ........  .......  ....................  .....................  ....................  .....................
#
    15.61%    cprog  [unknown]             [.] 00000000           cprog                 [.] sw_3_1           
     6.28%    cprog  cprog                 [.] symbol2            cprog                 [.] hw_1_2           
     6.28%    cprog  cprog                 [.] ctr_addr           cprog                 [.] sw_4_1           
     6.26%    cprog  cprog                 [.] success_3_1_3      cprog                 [.] sw_3_1           
     6.24%    cprog  cprog                 [.] symbol1            cprog                 [.] hw_1_1           
     6.24%    cprog  cprog                 [.] sw_4_2             cprog                 [.] callme           
     6.21%    cprog  [unknown]             [.] 00000000           cprog                 [.] callme           
     6.19%    cprog  cprog                 [.] lr_addr            cprog                 [.] sw_4_2           
     3.16%    cprog  cprog                 [.] hw_1_2             cprog                 [.] callme           
     3.15%    cprog  cprog                 [.] success_3_1_1      cprog                 [.] sw_3_1           
     3.15%    cprog  cprog                 [.] sw_4_1             cprog                 [.] callme           
     3.14%    cprog  cprog                 [.] callme             cprog                 [.] main             
     3.13%    cprog  cprog                 [.] hw_1_1             cprog                 [.] callme           
     3.13%    cprog  cprog                 [.] sw_3_1_1           cprog                 [.] sw_3_1           
     3.12%    cprog  cprog                 [.] back2              cprog                 [.] callme           
     3.12%    cprog  cprog                 [.] sw_3_1             cprog                 [.] callme           
     3.11%    cprog  cprog                 [.] back1              cprog                 [.] callme           
     3.11%    cprog  cprog                 [.] sw_3_1_2           cprog                 [.] sw_3_1           
     3.11%    cprog  cprog                 [.] sw_3_1_3           cprog                 [.] sw_3_1           
     3.10%    cprog  cprog                 [.] sw_3_2             cprog                 [.] callme           
     3.09%    cprog  cprog                 [.] success_3_1_2      cprog                 [.] sw_3_1           
     0.03%    cprog  [unknown]             [.] 0x100009b0         [unknown]             [.] 0xf7d5581c       
     0.01%    cprog  libc-2.11.2.so        [.] _IO_file_overflow  libc-2.11.2.so        [.] _IO_file_xsputn  
     0.01%    cprog  libc-2.11.2.so        [.] _IO_file_setbuf    [unknown]             [.] 0x0fee1084       
     0.01%    cprog  [unknown]             [.] 0xf7d5589c         libc-2.11.2.so        [.] printf           
     0.01%    cprog  [unknown]             [.] 00000000           libc-2.11.2.so        [.] _IO_file_overflow
     0.01%    cprog  [unknown]             [.] 00000000           libc-2.11.2.so        [.] _IO_file_setbuf  
     0.01%    cprog  [unknown]             [k] 00000000           cprog                 [k] callme           

(4) perf record -j ind_call  -e branch-misses:u ./cprog

# Overhead  Command  Source Shared Object   Source Symbol  Target Shared Object          Target Symbol
# ........  .......  ....................  ..............  ....................  .....................
#
    42.59%    cprog  [unknown]             [.] 00000000    cprog                 [.] sw_3_1           
    25.88%    cprog  cprog                 [.] sw_4_2      cprog                 [.] lr_addr          
    25.65%    cprog  [unknown]             [.] 00000000    cprog                 [.] callme           
     5.58%    cprog  cprog                 [.] sw_4_1      cprog                 [.] ctr_addr         
     0.23%    cprog  [unknown]             [k] 00000000    cprog                 [k] callme           
     0.05%    cprog  [unknown]             [.] 00000000    [unknown]             [.] 0xf79fd740       
     0.03%    cprog  [unknown]             [.] 00000000    libc-2.11.2.so        [.] _IO_file_overflow


(5) perf record -j any_call,any_ret -e branch-misses:u ./cprog

# Overhead  Command  Source Shared Object              Source Symbol  Target Shared Object          Target Symbol
# ........  .......  ....................  .........................  ....................  .....................
#
    10.00%    cprog  [unknown]             [.] 00000000               cprog                 [.] sw_3_1           
     4.20%    cprog  cprog                 [.] sw_4_2                 cprog                 [.] lr_addr          
     4.17%    cprog  cprog                 [.] lr_addr                cprog                 [.] sw_4_2           
     4.16%    cprog  cprog                 [.] symbol1                cprog                 [.] hw_1_1           
     4.12%    cprog  [unknown]             [.] 00000000               cprog                 [.] callme           
     4.12%    cprog  cprog                 [.] symbol2                cprog                 [.] hw_1_2           
     4.11%    cprog  cprog                 [.] success_3_1_3          cprog                 [.] sw_3_1           
     4.11%    cprog  cprog                 [.] ctr_addr               cprog                 [.] sw_4_1           
     4.10%    cprog  cprog                 [.] sw_4_2                 cprog                 [.] callme           
     2.42%    cprog  cprog                 [.] callme                 cprog                 [.] sw_4_2           
     2.40%    cprog  cprog                 [.] sw_3_1_3               cprog                 [.] sw_3_1           
     2.40%    cprog  cprog                 [.] sw_3_1                 cprog                 [.] sw_3_1_3         
     2.39%    cprog  cprog                 [.] hw_1_2                 cprog                 [.] symbol2          
     2.39%    cprog  cprog                 [.] back1                  cprog                 [.] callme           
     2.39%    cprog  cprog                 [.] sw_3_1_1               cprog                 [.] sw_3_1           
     2.39%    cprog  cprog                 [.] sw_3_1                 cprog                 [.] sw_3_1_1         
     2.39%    cprog  cprog                 [.] sw_3_1                 cprog                 [.] callme           
     2.39%    cprog  cprog                 [.] sw_4_1                 cprog                 [.] ctr_addr         
     2.39%    cprog  cprog                 [.] callme                 cprog                 [.] hw_1_2           
     2.39%    cprog  cprog                 [.] callme                 cprog                 [.] sw_3_1           
     2.39%    cprog  cprog                 [.] sw_3_1_2               cprog                 [.] sw_3_1           
     2.39%    cprog  cprog                 [.] sw_3_1                 cprog                 [.] sw_3_1_2         
     2.38%    cprog  cprog                 [.] hw_1_1                 cprog                 [.] symbol1          
     2.38%    cprog  cprog                 [.] callme                 cprog                 [.] hw_1_1           
     1.78%    cprog  cprog                 [.] back2                  cprog                 [.] callme           
     1.78%    cprog  cprog                 [.] hw_1_1                 cprog                 [.] callme           
     1.76%    cprog  cprog                 [.] success_3_1_2          cprog                 [.] sw_3_1           
     1.76%    cprog  cprog                 [.] sw_3_1                 cprog                 [.] success_3_1_2    
     1.76%    cprog  cprog                 [.] sw_3_2                 cprog                 [.] callme           
     1.76%    cprog  cprog                 [.] callme                 cprog                 [.] sw_3_2           
     1.73%    cprog  cprog                 [.] success_3_1_1          cprog                 [.] sw_3_1           
     1.73%    cprog  cprog                 [.] sw_3_1                 cprog                 [.] success_3_1_1    
     1.73%    cprog  cprog                 [.] hw_1_2                 cprog                 [.] callme           
     1.71%    cprog  cprog                 [.] sw_3_1                 cprog                 [.] success_3_1_3    
     1.71%    cprog  cprog                 [.] sw_4_1                 cprog                 [.] callme           
     1.71%    cprog  cprog                 [.] callme                 cprog                 [.] main             
     0.05%    cprog  [unknown]             [k] 00000000               cprog                 [k] callme           
     0.03%    cprog  [unknown]             [.] 0xf7aa9d4c             [unknown]             [.] 0xf7aa5f80       
     0.01%    cprog  libc-2.11.2.so        [.] __errno_location       libc-2.11.2.so        [.] vfprintf         
     0.01%    cprog  libc-2.11.2.so        [.] vfprintf               libc-2.11.2.so        [.] __errno_location 
     0.01%    cprog  libc-2.11.2.so        [.] _IO_doallocbuf         libc-2.11.2.so        [.] _IO_file_overflow
     0.01%    cprog  cprog                 [.] __do_global_dtors_aux  [unknown]             [.] 0xf7a9fc74       
     0.01%    cprog  [unknown]             [.] 0xf7a9fca4             cprog                 [.] _fini            

(6) perf record -j any_call,ind_call -e branch-misses:u ./cprog

# Overhead  Command  Source Shared Object           Source Symbol  Target Shared Object           Target Symbol
# ........  .......  ....................  ......................  ....................  ......................
#
    17.38%    cprog  [unknown]             [.] 00000000            cprog                 [.] sw_3_1            
     7.76%    cprog  cprog                 [.] sw_4_2              cprog                 [.] lr_addr           
     7.64%    cprog  [unknown]             [.] 00000000            cprog                 [.] callme            
     6.00%    cprog  cprog                 [.] sw_3_1              cprog                 [.] sw_3_1_1          
     6.00%    cprog  cprog                 [.] callme              cprog                 [.] sw_3_1            
     5.98%    cprog  cprog                 [.] sw_4_1              cprog                 [.] ctr_addr          
     5.97%    cprog  cprog                 [.] hw_1_1              cprog                 [.] symbol1           
     5.97%    cprog  cprog                 [.] hw_1_2              cprog                 [.] symbol2           
     5.97%    cprog  cprog                 [.] sw_3_1              cprog                 [.] sw_3_1_3          
     5.97%    cprog  cprog                 [.] callme              cprog                 [.] hw_1_1            
     5.97%    cprog  cprog                 [.] callme              cprog                 [.] hw_1_2            
     5.96%    cprog  cprog                 [.] callme              cprog                 [.] sw_4_2            
     5.95%    cprog  cprog                 [.] sw_3_1              cprog                 [.] sw_3_1_2          
     1.83%    cprog  cprog                 [.] sw_3_1              cprog                 [.] success_3_1_2     
     1.82%    cprog  cprog                 [.] sw_3_1              cprog                 [.] success_3_1_1     
     1.82%    cprog  cprog                 [.] sw_3_1              cprog                 [.] success_3_1_3     
     1.82%    cprog  cprog                 [.] callme              cprog                 [.] sw_3_2            
     0.14%    cprog  [unknown]             [k] 00000000            cprog                 [k] callme            
     0.01%    cprog  libc-2.11.2.so        [.] vfprintf            libc-2.11.2.so        [.] strchrnul         
     0.01%    cprog  libc-2.11.2.so        [.] _IO_file_xsputn     libc-2.11.2.so        [.] _IO_default_xsputn
     0.01%    cprog  libc-2.11.2.so        [.] _IO_default_xsputn  libc-2.11.2.so        [.] _IO_file_overflow 
     0.01%    cprog  ld-2.11.2.so          [.] calloc              [unknown]             [.] 0xf795b390        
     0.01%    cprog  [unknown]             [.] 0x0fee00fc          libc-2.11.2.so        [.] _IO_file_overflow 
     0.01%    cprog  [unknown]             [.] 00000000            ld-2.11.2.so          [.] calloc            
     0.01%    cprog  [unknown]             [.] 0xf794b41c          [unknown]             [.] 0xf794ab70        

(7) perf record -j cond,any_ret -e branch-misses:u ./cprog

# Overhead  Command  Source Shared Object           Source Symbol  Target Shared Object           Target Symbol
# ........  .......  ....................  ......................  ....................  ......................
#
    12.43%    cprog  [unknown]             [.] 00000000            cprog                 [.] sw_3_1            
     4.91%    cprog  cprog                 [.] lr_addr             cprog                 [.] sw_4_2            
     4.89%    cprog  [unknown]             [.] 00000000            cprog                 [.] callme            
     4.87%    cprog  cprog                 [.] sw_4_2              cprog                 [.] lr_addr           
     4.87%    cprog  cprog                 [.] symbol1             cprog                 [.] hw_1_1            
     4.19%    cprog  cprog                 [.] hw_2_2              cprog                 [.] address2          
     4.19%    cprog  cprog                 [.] back2               cprog                 [.] callme            
     4.19%    cprog  cprog                 [.] sw_3_2              cprog                 [.] callme            
     4.18%    cprog  cprog                 [.] hw_1_1              cprog                 [.] callme            
     4.18%    cprog  cprog                 [.] success_3_1_2       cprog                 [.] sw_3_1            
     4.18%    cprog  cprog                 [.] sw_3_1              cprog                 [.] success_3_1_2     
     4.16%    cprog  cprog                 [.] sw_4_2              cprog                 [.] callme            
     4.13%    cprog  cprog                 [.] ctr_addr            cprog                 [.] sw_4_1            
     4.12%    cprog  cprog                 [.] symbol2             cprog                 [.] hw_1_2            
     4.12%    cprog  cprog                 [.] success_3_1_3       cprog                 [.] sw_3_1            
     3.43%    cprog  cprog                 [.] callme              cprog                 [.] main              
     3.42%    cprog  cprog                 [.] sw_3_1              cprog                 [.] success_3_1_3     
     3.41%    cprog  cprog                 [.] success_3_1_1       cprog                 [.] sw_3_1            
     3.41%    cprog  cprog                 [.] sw_3_1              cprog                 [.] success_3_1_1     
     3.41%    cprog  cprog                 [.] sw_4_1              cprog                 [.] callme            
     3.40%    cprog  cprog                 [.] hw_1_2              cprog                 [.] callme            
     0.73%    cprog  cprog                 [.] sw_3_1_3            cprog                 [.] sw_3_1            
     0.73%    cprog  cprog                 [.] sw_4_1              cprog                 [.] ctr_addr          
     0.72%    cprog  cprog                 [.] hw_1_2              cprog                 [.] symbol2           
     0.72%    cprog  cprog                 [.] sw_3_1_1            cprog                 [.] sw_3_1            
     0.70%    cprog  cprog                 [.] hw_2_1              cprog                 [.] address1          
     0.70%    cprog  cprog                 [.] back1               cprog                 [.] callme            
     0.70%    cprog  cprog                 [.] sw_3_1_2            cprog                 [.] sw_3_1            
     0.70%    cprog  cprog                 [.] sw_3_1              cprog                 [.] callme            
     0.19%    cprog  [unknown]             [.] 0xf7c12328          [unknown]             [.] 0xf7c12320        
     0.01%    cprog  libc-2.11.2.so        [.] __errno_location    libc-2.11.2.so        [.] vfprintf          
     0.01%    cprog  libc-2.11.2.so        [.] vfprintf            libc-2.11.2.so        [.] vfprintf          
     0.01%    cprog  libc-2.11.2.so        [.] _IO_file_overflow   [unknown]             [.] 0x0fee0100        
     0.01%    cprog  libc-2.11.2.so        [.] _IO_default_xsputn  libc-2.11.2.so        [.] _IO_default_xsputn
     0.01%    cprog  [unknown]             [.] 00000000            libc-2.11.2.so        [.] _IO_file_overflow 

(8) perf record -j cond,ind_call -e branch-misses:u ./cprog

# Overhead  Command  Source Shared Object   Source Symbol  Target Shared Object      Target Symbol
# ........  .......  ....................  ..............  ....................  .................
#
    20.70%    cprog  [unknown]             [.] 00000000    cprog                 [.] sw_3_1       
     9.99%    cprog  cprog                 [.] sw_4_2      cprog                 [.] lr_addr      
     9.91%    cprog  [unknown]             [.] 00000000    cprog                 [.] callme       
     9.45%    cprog  cprog                 [.] sw_3_1_3    cprog                 [.] sw_3_1       
     9.44%    cprog  cprog                 [.] hw_2_1      cprog                 [.] address1     
     9.43%    cprog  cprog                 [.] sw_3_1_1    cprog                 [.] sw_3_1       
     9.42%    cprog  cprog                 [.] hw_1_2      cprog                 [.] symbol2      
     9.42%    cprog  cprog                 [.] sw_3_1_2    cprog                 [.] sw_3_1       
     9.42%    cprog  cprog                 [.] sw_4_1      cprog                 [.] ctr_addr     
     0.65%    cprog  cprog                 [.] sw_3_1      cprog                 [.] success_3_1_1
     0.62%    cprog  cprog                 [.] sw_3_1      cprog                 [.] success_3_1_3
     0.56%    cprog  cprog                 [.] hw_2_2      cprog                 [.] address2     
     0.55%    cprog  cprog                 [.] sw_3_1      cprog                 [.] success_3_1_2
     0.29%    cprog  [unknown]             [.] 0xf7f72328  [unknown]             [.] 0xf7f72320   
     0.10%    cprog  [unknown]             [k] 00000000    cprog                 [k] callme       
     0.02%    cprog  libc-2.11.2.so        [.] _IO_setb    libc-2.11.2.so        [.] _IO_setb     

(9) perf record -e branch-misses:u -j any_call,any_ret,ind_call,cond ./cprog

# Overhead  Command  Source Shared Object       Source Symbol  Target Shared Object            Target Symbol
# ........  .......  ....................  ..................  ....................  .......................
#
     9.31%    cprog  [unknown]             [.] 00000000        cprog                 [.] sw_3_1             
     4.04%    cprog  cprog                 [.] symbol1         cprog                 [.] hw_1_1             
     4.03%    cprog  cprog                 [.] lr_addr         cprog                 [.] sw_4_2             
     4.03%    cprog  cprog                 [.] sw_4_2          cprog                 [.] lr_addr            
     4.00%    cprog  [unknown]             [.] 00000000        cprog                 [.] callme             
     3.88%    cprog  cprog                 [.] ctr_addr        cprog                 [.] sw_4_1             
     3.87%    cprog  cprog                 [.] sw_4_2          cprog                 [.] callme             
     3.86%    cprog  cprog                 [.] symbol2         cprog                 [.] hw_1_2             
     3.86%    cprog  cprog                 [.] success_3_1_3   cprog                 [.] sw_3_1             
     2.49%    cprog  cprog                 [.] sw_4_1          cprog                 [.] ctr_addr           
     2.47%    cprog  cprog                 [.] hw_1_1          cprog                 [.] symbol1            
     2.47%    cprog  cprog                 [.] sw_3_1_1        cprog                 [.] sw_3_1             
     2.47%    cprog  cprog                 [.] sw_3_1          cprog                 [.] sw_3_1_1           
     2.47%    cprog  cprog                 [.] callme          cprog                 [.] hw_1_1             
     2.47%    cprog  cprog                 [.] callme          cprog                 [.] sw_3_1             
     2.47%    cprog  cprog                 [.] hw_1_2          cprog                 [.] symbol2            
     2.47%    cprog  cprog                 [.] hw_2_1          cprog                 [.] address1           
     2.47%    cprog  cprog                 [.] back1           cprog                 [.] callme             
     2.47%    cprog  cprog                 [.] sw_3_1_3        cprog                 [.] sw_3_1             
     2.47%    cprog  cprog                 [.] sw_3_1          cprog                 [.] sw_3_1_3           
     2.47%    cprog  cprog                 [.] sw_3_1          cprog                 [.] callme             
     2.47%    cprog  cprog                 [.] callme          cprog                 [.] hw_1_2             
     2.47%    cprog  cprog                 [.] callme          cprog                 [.] sw_4_2             
     2.46%    cprog  cprog                 [.] sw_3_1_2        cprog                 [.] sw_3_1             
     2.46%    cprog  cprog                 [.] sw_3_1          cprog                 [.] sw_3_1_2           
     1.57%    cprog  cprog                 [.] success_3_1_2   cprog                 [.] sw_3_1             
     1.57%    cprog  cprog                 [.] sw_3_1          cprog                 [.] success_3_1_2      
     1.57%    cprog  cprog                 [.] hw_1_1          cprog                 [.] callme             
     1.56%    cprog  cprog                 [.] hw_2_2          cprog                 [.] address2           
     1.56%    cprog  cprog                 [.] back2           cprog                 [.] callme             
     1.56%    cprog  cprog                 [.] sw_3_2          cprog                 [.] callme             
     1.56%    cprog  cprog                 [.] callme          cprog                 [.] sw_3_2             
     1.41%    cprog  cprog                 [.] success_3_1_1   cprog                 [.] sw_3_1             
     1.41%    cprog  cprog                 [.] sw_3_1          cprog                 [.] success_3_1_1      
     1.40%    cprog  cprog                 [.] sw_4_1          cprog                 [.] callme             
     1.39%    cprog  cprog                 [.] hw_1_2          cprog                 [.] callme             
     1.39%    cprog  cprog                 [.] sw_3_1          cprog                 [.] success_3_1_3      
     1.39%    cprog  cprog                 [.] callme          cprog                 [.] main               
     0.14%    cprog  [unknown]             [.] 0xf7d72328      [unknown]             [.] 0xf7d72320         
     0.03%    cprog  [unknown]             [k] 00000000        cprog                 [k] callme             
     0.01%    cprog  libc-2.11.2.so        [.] _IO_doallocbuf  libc-2.11.2.so        [.] _IO_doallocbuf     
     0.01%    cprog  libc-2.11.2.so        [.] printf          cprog                 [.] main               
     0.01%    cprog  libc-2.11.2.so        [.] _IO_doallocbuf  libc-2.11.2.so        [.] _IO_file_doallocate
     0.01%    cprog  ld-2.11.2.so          [.] malloc          [unknown]             [.] 0xf7d8b380         
     0.01%    cprog  cprog                 [.] main            [unknown]             [.] 0x0fe7f63c         
     0.01%    cprog  [unknown]             [.] 0xf7d8b388      ld-2.11.2.so          [.] __libc_memalign    
     0.01%    cprog  [unknown]             [.] 00000000        ld-2.11.2.so          [.] malloc             

Please refer to the V4 version of the patchset to learn about the sample test case and it's makefile.

Anshuman Khandual (11):
  perf: Add PERF_SAMPLE_BRANCH_COND
  perf, tool: Conditional branch filter 'cond' added to perf record
  x86, perf: Add conditional branch filtering support
  perf, documentation: Description for conditional branch filter
  powerpc, perf: Re-arrange BHRB processing
  powerpc, perf: Re-arrange PMU based branch filter processing in POWER8
  powerpc, perf: Change the name of HW PMU branch filter tracking variable
  powerpc, lib: Add new branch analysis support functions
  powerpc, perf: Enable SW filtering in branch stack sampling framework
  power8, perf: Adapt BHRB PMU configuration to work with SW filters
  powerpc, perf: Enable privilege mode SW branch filters

 arch/powerpc/include/asm/code-patching.h     |  16 ++
 arch/powerpc/include/asm/perf_event_server.h |   6 +-
 arch/powerpc/lib/code-patching.c             |  80 +++++++
 arch/powerpc/perf/core-book3s.c              | 323 ++++++++++++++++++++++-----
 arch/powerpc/perf/power8-pmu.c               |  70 ++++--
 arch/x86/kernel/cpu/perf_event_intel_lbr.c   |   5 +
 include/uapi/linux/perf_event.h              |   3 +-
 tools/perf/Documentation/perf-record.txt     |   3 +-
 tools/perf/builtin-record.c                  |   1 +
 9 files changed, 429 insertions(+), 78 deletions(-)

-- 
1.7.11.7

