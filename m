Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893AbaLEUoW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 15:44:22 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:36162 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183AbaLEUoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 15:44:20 -0500
Message-ID: <5482191E.5050309@linux.vnet.ibm.com>
Date: Fri, 05 Dec 2014 15:44:14 -0500
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Peter Huewe <PeterHuewe@gmx.de>
CC: christophe.ricard@gmail.com, josh.triplett@intel.com,
        linux-api@vger.kernel.org, Ashley Lai <ashley@ashleylai.com>,
        linux-kernel@vger.kernel.org, Will Arthur <will.c.arthur@intel.com>,
        tpmdd-devel@lists.sourceforge.net,
        jason.gunthorpe@obsidianresearch.com,
        trousers-tech@lists.sourceforge.net
Subject: Re: [tpmdd-devel] [PATCH v9 8/8] tpm: TPM 2.0 FIFO Interface
References: <1417672518-4530-1-git-send-email-jarkko.sakkinen@linux.intel.com> <1417672518-4530-9-git-send-email-jarkko.sakkinen@linux.intel.com> <201412042318.33889.PeterHuewe@gmx.de>, <201412042328.29578.PeterHuewe@gmx.de> <trinity-0fea8cea-4011-4d04-af4a-e7583a7184b4-1417791661803@3capp-gmx-bs52>
In-Reply-To: <trinity-0fea8cea-4011-4d04-af4a-e7583a7184b4-1417791661803@3capp-gmx-bs52>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120520-0033-0000-0000-0000013D2177
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2014 10:01 AM, Peter Huewe wrote:
>>> Am Donnerstag, 4. Dezember 2014, 06:55:18 schrieb Jarkko Sakkinen:
>>>> From: Will Arthur <will.c.arthur@intel.com>
>>>>
>>>> Detect TPM 2.0 by using the extended STS (STS3) register. For TPM 2.0,
>>>> instead of calling tpm_get_timeouts(), assign duration and timeout
>>>> values defined in the TPM 2.0 PTP specification.
>>>>
>>>> Signed-off-by: Will Arthur <will.c.arthur@intel.com>
>>>> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
>>>> + sts3 = ioread8(chip->vendor.iobase + TPM_STS3(1));
>>>> + if ((sts3 & TPM_STS3_TPM2_FAM) == TPM_STS3_TPM2_FAM)
>>>> + chip->flags = TPM_CHIP_FLAG_TPM2;
>>>> +
>>>>
>>> When loading tpm_tis force=1 with my tpm1.2 chip on a machine without bios
>>> integration, it fets detected as a TPM2.0 chip :/
>>>
>>> sudo rmmod tpm_tis
>>> # modprobe tpm_tis force=1
>>> modprobe: ERROR: could not insert 'tpm_tis': No such device
>>> # dmesg
>>> [ 263.903828] tpm_tis tpm_tis: 2.0 TPM (device-id 0xB, rev-id 16)
>>> [ 263.948049] tpm_tis tpm_tis: A TPM error (10) occurred continue selftest
>>> [ 263.948120] tpm_tis tpm_tis: TPM self test failed
>>>
>>>
>>> sts3 is reported as 0xff from my TPM1.2
>>>
>>
>> Hmm,
>> my TPM2.0 chip also reports sts3 as 0xff (when loading with force=1 on a
>> machine without bios integration)
>>
>> [ 307.095344] sts3 ff
>> [ 307.095366] tpm_tis tpm_tis: 2.0 TPM (device-id 0x1A, rev-id 16)
>> [ 307.140047] tpm_tis tpm_tis: A TPM error (256) occurred continue selftest
>> [ 307.140056] tpm_tis tpm_tis: TPM self test failed
>
> You are reading "sts3" - before requesting the locality and thus it returns 0xff for a TPM20 chip as well.
> --> You have to have an active locality first.
>
>
> For a TPM2.0 0xFF is not a valid value (if active locality is set), since reading commandCancel and resetEstablishment bit always return 0 on reads (according to spec).
>
> --> 0xFF should be treated as a TPM1.2 (older tpms with TIS 1.2)
> --> 0x04 should be treated as TPM 2.0
> --> 0x08 should be treated as TPM1.2 (newer tpms with TIS1.3 enhanced)

> + sts3 = ioread8(chip->vendor.iobase + TPM_STS3(1));
> + if ((sts3 & TPM_STS3_TPM2_FAM) == TPM_STS3_TPM2_FAM)
> + chip->flags = TPM_CHIP_FLAG_TPM2;

#define TPM_STS3_TPM2_FAM_MASK = 0x0c

then:

if ((sts3 & TPM_STS3_TPM2_FAM_MASK) == TPM_STS3_TPM2_FAM) ...

[see my previous review on this]

    Stefan






>
>
>
> Thanks,
> Peter
>
> ------------------------------------------------------------------------------
> Download BIRT iHub F-Type - The Free Enterprise-Grade BIRT Server
> from Actuate! Instantly Supercharge Your Business Reports and Dashboards
> with Interactivity, Sharing, Native Excel Exports, App Integration & more
> Get technology previously reserved for billion-dollar corporations, FREE
> http://pubads.g.doubleclick.net/gampad/clk?id=164703151&iu=/4140/ostg.clktrk
> _______________________________________________
> tpmdd-devel mailing list
> tpmdd-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/tpmdd-devel
>

