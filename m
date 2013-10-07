Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461Ab3JGPHI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 11:07:08 -0400
Received: from emvm-gh1-uea09.nsa.gov ([63.239.67.10]:61404 "EHLO nsa.gov"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751436Ab3JGPHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 11:07:06 -0400
X-TM-IMSS-Message-ID: <5112f96500056f0f@nsa.gov>
Message-ID: <5252CDF2.4090304@tycho.nsa.gov>
Date: Mon, 07 Oct 2013 11:06:26 -0400
From: Daniel De Graaf <dgdegra@tycho.nsa.gov>
Organization: National Security Agency
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
CC: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Rajiv Andrade <mail@srajiv.net>,
        tpmdd-devel@lists.sourceforge.net,
        Richard Maciel Costa <richardm@br.ibm.com>,
        "trousers-tech@lists.sourceforge.net" 
	<trousers-tech@lists.sourceforge.net>,
        Sirrix AG <tpmdd@sirrix.com>
Subject: Re: [tpmdd-devel] [PATCH 09/13] tpm: Pull everything related to sysfs
 into tpm-sysfs.c
References: <52408E5D.4020904@tycho.nsa.gov> <20130923193633.GA9194@obsidianresearch.com>	<5240A2A3.4040102@tycho.nsa.gov> <20130923204232.GB16345@obsidianresearch.com> <5240BA0E.3000304@tycho.nsa.gov>	<20130923222324.GA9533@obsidianresearch.com> <5241A199.1080505@tycho.nsa.gov> <20130930181005.GG28898@obsidianresearch.com> <5249E0CB.2070106@tycho.nsa.gov>	<5249F6AF.7050608@linux.vnet.ibm.com> <20131004170803.GB6955@obsidianresearch.com> <524F1450.6060406@linux.vnet.ibm.com>
In-Reply-To: <524F1450.6060406@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2013 03:17 PM, Stefan Berger wrote:
> On 10/04/2013 01:08 PM, Jason Gunthorpe wrote:
>> On Mon, Sep 30, 2013 at 05:09:51PM -0500, Joel Schopp wrote:
>>
>>>> So far, nobody I have talked to has offered any strong opinions on
>>>> what locality should be used or how it should be set. I think finding
>>>> a developer of trousers may be the most useful to talk about how the
>>>> ioctl portion of this would need to be set up - if someone is actually
>>>> needed.
>>> I am a TrouSerS developer and am ccing Richard, another TrouSerS
>>> developer, and ccing the trousers-tech list.  It would be good if you
>>> could elaborate on the question and context for those not following the
>>> entire thread, myself included.
>> Two questions:
>>
>> Is userspace interested in using the TPM Locality feature, and if so
>> is there any thoughts on what the interface should be?
>
> In terms of interface it should probably be an ioctl so that whoever
> holds the fd to /dev/tpm0 gets to choose the locality.
>
> Locality allows the resetting of certain PCRs. See section 3.7 in
>
> http://www.trustedcomputinggroup.org/files/static_page_files/8E45D739-1A4B-B294-D06274E7047730FD/TCG_PCClientTPMInterfaceSpecification_TIS__1-3_27_03212013.pdf
>
> Locality 4 can only be used by the hardware (section 2.2).
>
> Locality has an influence on the following TPM commands:
> TSC_ResetEstablishmentBit, Seal, Sealx, CreateWrapKey, UnSeal,
> GetPubKey, CMK_CreateKey, SHA1CompleteExtend, CertifyKey, Extend,
> PCR_Reset, NV_ReadValue, NV_WriteValue, and others.  Some of the
> commands allow operations to succeed if a previously selected locality
> is also currently the chosen one. (If you have control over choosing the
> locality, at least that part won't prevent you from succeeding..)
>
> http://www.trustedcomputinggroup.org/files/static_page_files/72C33D71-1A4B-B294-D02C7DF86630BE7C/TPM%20Main-Part%203%20Commands_v1.2_rev116_01032011.pdf
>
> The worst would probably be if an application was to reset a PCR while
> another one is using that PCR or just for malicious purposes. Not
> providing support for choosing locality would mean that applications
> could still use PCRs 16 and 23 for their own purposes and can compete
> for their exclusive usage while being able to reset only those two.

Any important measurements that would be impacted by a userspace-generated
reset should be directed to the non-resettable PCR 0-15 or 17-19 (allowing
DRTM to reset them). Ideally the /dev/tpm0 device would be opened only by
tcsd (which could be measured by IMA and enforced by an LSM), which could
implement its own restrictions on what clients can extend or reset PCRs.

> Are there use case for resetting PCRs from user space? If not I'd not
> support choice for locality from user space.
>
>       Stefan

It's not just resetting - extends to PCR 17-22 are also restricted based on
locality, so without this interface they have been read-only.

There are use cases that are significantly simplified by using multiple
resettable PCRs. One (slightly contrived) example: tcsd manages one PCR so
that it holds the hash of the executable making a local IPC request, another
holds the arguments or pathname, another the IMA signature key used to sign
the application. This allows the application (say, a keyring) to seal data
that only it can unseal; without multiple PCRs, a more complex interface
would be required to support a choice between sealing to the more flexible
IMA signature in order to support software upgrades and sealing to the more
secure exact binary image.

-- 
Daniel De Graaf
National Security Agency
