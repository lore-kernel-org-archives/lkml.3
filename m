Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab3JDTRn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 15:17:43 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:45141 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577Ab3JDTRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 15:17:42 -0400
Message-ID: <524F1450.6060406@linux.vnet.ibm.com>
Date: Fri, 04 Oct 2013 15:17:36 -0400
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: Joel Schopp <jschopp@linux.vnet.ibm.com>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Rajiv Andrade <mail@srajiv.net>,
        tpmdd-devel@lists.sourceforge.net,
        Richard Maciel Costa <richardm@br.ibm.com>,
        "trousers-tech@lists.sourceforge.net" 
	<trousers-tech@lists.sourceforge.net>,
        Sirrix AG <tpmdd@sirrix.com>
Subject: Re: [tpmdd-devel] [PATCH 09/13] tpm: Pull everything related to sysfs
 into tpm-sysfs.c
References: <52408E5D.4020904@tycho.nsa.gov> <20130923193633.GA9194@obsidianresearch.com>	<5240A2A3.4040102@tycho.nsa.gov> <20130923204232.GB16345@obsidianresearch.com> <5240BA0E.3000304@tycho.nsa.gov>	<20130923222324.GA9533@obsidianresearch.com> <5241A199.1080505@tycho.nsa.gov> <20130930181005.GG28898@obsidianresearch.com> <5249E0CB.2070106@tycho.nsa.gov>	<5249F6AF.7050608@linux.vnet.ibm.com> <20131004170803.GB6955@obsidianresearch.com>
In-Reply-To: <20131004170803.GB6955@obsidianresearch.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100419-7182-0000-0000-000008A31AC8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2013 01:08 PM, Jason Gunthorpe wrote:
> On Mon, Sep 30, 2013 at 05:09:51PM -0500, Joel Schopp wrote:
>
>>> So far, nobody I have talked to has offered any strong opinions on
>>> what locality should be used or how it should be set. I think finding
>>> a developer of trousers may be the most useful to talk about how the
>>> ioctl portion of this would need to be set up - if someone is actually
>>> needed.
>> I am a TrouSerS developer and am ccing Richard, another TrouSerS
>> developer, and ccing the trousers-tech list.  It would be good if you
>> could elaborate on the question and context for those not following the
>> entire thread, myself included.
> Two questions:
>
> Is userspace interested in using the TPM Locality feature, and if so
> is there any thoughts on what the interface should be?

In terms of interface it should probably be an ioctl so that whoever 
holds the fd to /dev/tpm0 gets to choose the locality.

Locality allows the resetting of certain PCRs. See section 3.7 in

http://www.trustedcomputinggroup.org/files/static_page_files/8E45D739-1A4B-B294-D06274E7047730FD/TCG_PCClientTPMInterfaceSpecification_TIS__1-3_27_03212013.pdf

Locality 4 can only be used by the hardware (section 2.2).

Locality has an influence on the following TPM commands: 
TSC_ResetEstablishmentBit, Seal, Sealx, CreateWrapKey, UnSeal, 
GetPubKey, CMK_CreateKey, SHA1CompleteExtend, CertifyKey, Extend, 
PCR_Reset, NV_ReadValue, NV_WriteValue, and others.  Some of the 
commands allow operations to succeed if a previously selected locality 
is also currently the chosen one. (If you have control over choosing the 
locality, at least that part won't prevent you from succeeding..)

http://www.trustedcomputinggroup.org/files/static_page_files/72C33D71-1A4B-B294-D02C7DF86630BE7C/TPM%20Main-Part%203%20Commands_v1.2_rev116_01032011.pdf

The worst would probably be if an application was to reset a PCR while 
another one is using that PCR or just for malicious purposes. Not 
providing support for choosing locality would mean that applications 
could still use PCRs 16 and 23 for their own purposes and can compete 
for their exclusive usage while being able to reset only those two.

Are there use case for resetting PCRs from user space? If not I'd not 
support choice for locality from user space.

     Stefan

>
> Is the kernel interested in using the TPM Locality feature? What for?
>
> Jason
>
> ------------------------------------------------------------------------------
> October Webinars: Code for Performance
> Free Intel webinars can help you accelerate application performance.
> Explore tips for MPI, OpenMP, advanced profiling, and more. Get the most from
> the latest Intel processors and coprocessors. See abstracts and register >
> http://pubads.g.doubleclick.net/gampad/clk?id=60134791&iu=/4140/ostg.clktrk
> _______________________________________________
> tpmdd-devel mailing list
> tpmdd-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/tpmdd-devel
>

