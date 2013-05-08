Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816Ab3EHOEd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 10:04:33 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:33382 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756353Ab3EHOEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 10:04:30 -0400
Date: Wed, 8 May 2013 10:03:42 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, fenghua.yu@intel.com,
        xen-devel@lists.xensource.com
Subject: Re: v3.9 - CPU hotplug and microcode earlier loading hits a mutex
 deadlock (x86_cpu_hotplug_driver_mutex)
Message-ID: <20130508140342.GA8152@phenom.dumpdata.com>
References: <20130506125937.GA14036@phenom.dumpdata.com>
 <20130507190024.GA4303@phenom.dumpdata.com>
 <20130508125414.GB30955@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130508125414.GB30955@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 08, 2013 at 02:54:14PM +0200, Borislav Petkov wrote:
> On Tue, May 07, 2013 at 03:00:24PM -0400, Konrad Rzeszutek Wilk wrote:
> > I dug deeper in how QEMU does it and it looks to be actually doing
> > the right thing. It triggers the ACPI SCI, the method that figures
> > out the CPU online/offline bits kicks off the right OSPM notification
> > and everything is going through ACPI (so _STA is on the processor is
> > checked, returns 0x2 (ACPI_STA_DEVICE_PRESENT), MADT has now the CPU
> > marked as enabled).
> 
> AFAIUC, you mean physical hotplug here which is done with ACPI, right?

Yes.

> And, if so, we actually need an x86 machine which supports that to test
> it on. Also, is this how physical hotplug is done? Put the number of
> max. supported CPUs in MADT and those which are not present are marked
> as disabled?
> 
> Then, when they're physically hotplugged, ACPI marks them as enabled?

Yes. The GPE is raised (by QEMU), the ACPI Method PRSC is invoked:

 Scope (_GPE)                                                                
    {                                                                           
        Method (_L02, 0, NotSerialized)                                         
        {                                                                       
            Return (\_SB.PRSC ())                                               
        }                                                                       
    }                                                                           
                                

Which iterates over the AXF00 (32 bytes) and checks each bit to see if
it is enabled (so CPU is on) or disabled. Then if it is different
from the MADT.FLG entry (so the 'flags' entry in the MADT), it updates
the MADT entry to have one (or zero if it has been disabled). And then
Notifies the Processor. Here is what the Processor entry looks like:

  Processor (PR02, 0x02, 0x0000B010, 0x06)                                
        {                                                                       
            Name (_HID, "ACPI0007")                                             
            OperationRegion (MATR, SystemMemory, Add (MAPA, 0x10), 0x08)        

[MAPA is the physical address to the MADT, the 0x10 increases by eight
bytes for each CPU]

            Field (MATR, ByteAcc, NoLock, Preserve)                             
            {                                                                   
                MAT,    64                                                      
            }                                                                   

[so it is 64 bits, the MAT is used in the '_STA' method to return the whole
contents of said memory location]
                                                                                
            Field (MATR, ByteAcc, NoLock, Preserve)                             
            {                                                                   
                        Offset (0x04),                                          
                FLG,    1                                                       
            }     
[and FLG is at offset 4 (out of 8 bytes), which means it lands on the
lapic->flags entry]                                                              
                                       
The PRSC method does what I mentioned above.
                                                                           
        OperationRegion (PRST, SystemIO, 0xAF00, 0x20)                          
        Field (PRST, ByteAcc, NoLock, Preserve)                                 
        {                                                                       
            PRS,    15                                                          
        }                                                                       
                                                                                
        Method (PRSC, 0, NotSerialized)                                         
        {                                                                       
            Store (ToBuffer (PRS), Local0)                                      
[Local0 has now the 32 bytes of data]

            Store (DerefOf (Index (Local0, Zero)), Local1)                      

[Local1 has now the zero-th byte of the 32-bytes. Each bit is one CPU, so
it contains the value of eight CPUs]

            And (Local1, One, Local2)                                           

[Local2 = gpe_state.cpu_sts[i] & 1, aka first CPU]

            If (LNotEqual (Local2, ^PR00.FLG))                                  
            {                                                                   
                Store (Local2, ^PR00.FLG)                                       

[Write the bit in the PR00.FLG, so at offset four in the MADT]

                If (LEqual (Local2, One))                                       
                {                                                               
[If it was enabled, and now is disabled, then notify with 1]
                    Notify (PR00, One)                                          
                    Subtract (MSU, One, MSU)                                    
[fix up the checksum]
                }                                                               
                Else                                                            
                {                                                               
                    Notify (PR00, 0x03)                                         
[if it was disabled, and now enabled, then notify with 0x3]
                    Add (MSU, One, MSU)                    
[again, fix up the checksum]
                     
                }                                                               
            }                                                                   
                                                                                
            ShiftRight (Local1, One, Local1)              

[here it shifts and continues on testing each CPU bit]

> Questions over questions...?

I probably went overboard with my answers :-)
> 
> > I am now 99% sure you would be able to reproduce this on baremetal with
> > ACPI hotplug where the CPUs at bootup are marked as disabled in MADT.
> > (lapic->lapic_flags == 0).
> > 
> > The comment for calling save_mc_for_early says:
> 
> Looks like save_mc_for_early would need another, local mutex to fix that.

Let me try that. Thanks for the suggestion.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> Sent from a fat crate under my desk. Formatting is fine.
> --
