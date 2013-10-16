Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760601Ab3JPKft (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 06:35:49 -0400
Received: from mailout4.w2.samsung.com ([211.189.100.14]:25583 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760182Ab3JPKfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 06:35:47 -0400
X-AuditID: cbfec373-b7f6d6d00000330d-f6-525e6c028b41
Date: Wed, 16 Oct 2013 07:35:39 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        "Chen, Gong" <gong.chen@linux.intel.com>, tony.luck@intel.com,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Aristeu Rozanski Filho <arozansk@redhat.com>,
        Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 8/8] ACPI / trace: Add trace interface for eMCA driver
Message-id: <20131016073539.5a48f65e.m.chehab@samsung.com>
In-reply-to: <20131016091640.GA13608@pd.tnic>
References: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com>
 <1381473166-29303-9-git-send-email-gong.chen@linux.intel.com>
 <20131015165435.GA2777@naverao1-tp.ibm.com> <20131015170039.GF7908@pd.tnic>
 <525D7BCD.7080303@linux.vnet.ibm.com>
 <20131015214346.68718bcd.m.chehab@samsung.com> <20131016091640.GA13608@pd.tnic>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.19; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOLMWRmVeSWpSXmKPExsVy+t/hEF2mnLggg7nXRC3aTvxms/i84R+b
	xa13thbL9/UzWlzeNYfN4n7LU3aLM4cOMVq8uXCPxYHD43trH4vH4j0vmTzmnQz0eHBoM4vH
	+31X2Tw+b5ILYIvisklJzcksSy3St0vgyvjypIOlYI58Rd+3aUwNjEcluhg5OSQETCSuLH/K
	DmGLSVy4t56ti5GLQ0hgCaPE6km9UE4jk8S1B52sIFUsAqoSx1ffYAGx2QSMJF41toDFRQSU
	JL4umssE0sAs0MUkcW7FJ7CxwgJeEqda7jCB2LwCVhLvd65lA7E5BXQlls9rYoHYcJFJ4sqH
	TUAJDqA7nCS2TvWFqBeU+DH5HtgyZgEtic3bmlghbHmJzWveMk9gFJiFpGwWkrJZSMoWMDKv
	YhQtLU4uKE5KzzXSK07MLS7NS9dLzs/dxAgJ/OIdjC82WB1iFOBgVOLhPREVGyTEmlhWXJl7
	iFGCg1lJhDciOC5IiDclsbIqtSg/vqg0J7X4ECMTB6dUA+O6X7Vhr1i27bA6Jtag+s9OmeX/
	/IyX6g+CswTaZ9uXvzloEBfBILZ+6SarvzrJ31wfqAkk3Zcw1k5+2Pk4/kPD5PAb1wU/nWqr
	fnGMPfjr69hHrne4TU4tO7Y1Zo7Rgx9/pA1rSozerOC/oNd0vqJZ6KDlrDm7z61h+3fj/Hf1
	hZ8at/FbLritxFKckWioxVxUnAgAVxuLOFoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, 16 Oct 2013 11:16:40 +0200
Borislav Petkov <bp@alien8.de> escreveu:

> On Tue, Oct 15, 2013 at 09:43:46PM -0300, Mauro Carvalho Chehab wrote:
> > > +		const uuid_le *fru_id,
> > Using a custom typedef here seems problematic, as that can make userspace
> > interface more complicated.

> It is defined in a userspace header: include/uapi/linux/uuid.h

Hmm... a non-packed structure is defined there. Ok, it has 16 bytes.
I generally avoid using non-packed structs on uapi, as the compiler
alignment rules can cause troubles if kernelspace is compiled with 64
bits, and userspace with 32 bits. In this specific case, it looks ok.
 
> 
> > > >>> +		char *fru_text,
> > > >>> +		u64 error_count,
> > > >>> +		u32 severity,
> > > >>> +		u64 phy_addr,
> > > >>> +		char *mem_loc),
> > 
> > By looking on the rest of the changes, the mem_loc can now contain the 
> > right location of the memory error, including on what DIMM the error
> > happened. It can also (optionally) contain the DIMM label.
> 
> No, dimm_loc contains the label.

Yeah, right. This is badly named, then.

Anyway, the dimm_loc is filled from DMI table by dmi_memdev_name().
Based on past experiences, this can be problematic, as manufactures tend
to re-use the same DMI table on machines with different layouts.

Tony/Chen,

Are there any changes with regards to that, like some enforcement policy
for BIOS manufacturers to make it right?

If not, then I think we still need EDAC's code to allow overriding those
labels by the ones actually found on the system.

> > Also, userspace needs to know what's the granularity for the error
> > that an eMCA driver will give, in order to adjust its policies.
> 
> u32 error_count

I'm talking about granularity, not error count. I mean: how the memory
is organized, what happens with errors that could be affecting more than
one DIMM (for example, on mirrored memories), etc.

Userspace can only do something useful if it knows what kind of support
the hardware error mechanism is providing.

> > If you don't create the EDAC nodes, it means that userspace doesn't
> > have any glue about what error information will be provided.
> 
> Of course it does - it is a tracepoint. There's no need for EDAC at all
> with eMCA present on the system.

Well, try to write some code on userspace to discover what's the error.

An error threshold mechanism on userspace will only work if userspace 
knows that the error belongs to the same DIMM.

If several different DIMMs are showing errors at the very same channel, and
replacing those dimms don't happen, that likely means that the channel BUS
is damaged.

What I'm saying is that hiding those information from userspace doesn't
help at all to improve the quality of the error report mechanism.

I can't see any reason why hiding those information from userspace.

The tracepoint interface is not for that. Such data is provided via sysfs,
and should be used for the application to properly tune their algorithms.

> > In any case, this is provided by the EDAC core functions that describe
> > the memory in details. So, IMHO, get rid of EDAC is a big mistake.
> 
> No one said we're getting rid of EDAC - we're basically disabling its
> services on machines with eMCA because we simply don't need it.

We do need, if we want do do a good job decoding the errors.

> > It is also nice to allow the user to choose his preferred mechanism,
> > when more than one is properly supported on a given system.
> 
> We did this with firmware-first reporting so I don't see any need
> for user interaction. When you have eMCA on the system, you disable
> everything else reporting memory errors and go to sleep. So, similar to
> firmware first.
> 
> If eMCA turns out to have f*cked BIOS implementations - which I don't
> doubt - then we can add a chicken bit similar to "acpi=nocmcff"
> 
> It is that simple.
> 

Works for me.

Regards,
Mauro
