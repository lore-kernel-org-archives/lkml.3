Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652AbaBQW5b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:57:31 -0500
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:2540
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751445AbaBQW51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 17:57:27 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.221;KIP:(null);UIP:(null);IPV:NLI;H:atltwp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VPS-5(zzbb2dI98dI9371Ie0eah1432I4015Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzzz2dh839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h190ch1946h19b4h19c3h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24ach24d7h2516h2545h255eh1155h)
X-WSS-ID: 0N15W4T-07-6DY-02
X-M-MSG: 
Message-ID: <53028EE8.20106@amd.com>
Date: Mon, 17 Feb 2014 16:36:24 -0600
From: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: <dougthompson@xmission.com>, <linux-edac@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] EDAC, MCE, AMD: Fix code to prevent NULL dereference
References: <1392659391-2411-1-git-send-email-Aravind.Gopalakrishnan@amd.com> <20140217182729.GE4559@pd.tnic> <5302625C.4050700@amd.com> <20140217194153.GG4559@pd.tnic>
In-Reply-To: <20140217194153.GG4559@pd.tnic>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/17/2014 1:41 PM, Borislav Petkov wrote:
> On Mon, Feb 17, 2014 at 01:26:20PM -0600, Aravind Gopalakrishnan wrote:
>>>   	if (c->x86_vendor != X86_VENDOR_AMD)
>>> -		return 0;
>>> +		return -ENODEV;
>>>   	if (c->x86 < 0xf || c->x86 > 0x16)
>>> -		return 0;
>>> +		return -ENODEV;
>>
> But we still need a fix, I guess the one I sent you does the job, yes,
> no?

Actually, the changes you sent above does the job only if 'edac-mce-amd' 
is configured as module.
If it is built-in (and looks like this is what Kconfig recommends as 
well..), then -
   * We can still modprobe mce_amd_inj
   * inject error
   * mce_amd_inj calls into amd_decode_mce and
   * this for mc0, mc1 and mc2 will lead to NULL dereference if family 
is unsupported.

So we'd still need the patch I sent earlier.
I guess what we really need is a mash-up of both changes..

> If not, I'd need more background info though - you're loading this on an
> unsupported family, right?
Yes. (more or less :) )
(background info to make things clear-)
someone did try this on unsupported HW and got kernel oops.
But since I can't get my hands on one,  I am simulating it by using a 
fam15, M30h box and setting the init condition as
      if (c->x86 < 0xf || c->x86 > 0x14)

snapshot of the oops from simulating on my system:
[   28.846200] [Hardware Error]: MC0 Error:
[   28.846218] BUG: unable to handle kernel NULL pointer dereference 
at           (null)
[   28.846232] IP: [<ffffffff81608526>] amd_decode_mce+0x526/0x900
[   28.846247] PGD 40bc9e067 PUD 40c677067 PMD 0
[   28.846257] Oops: 0000 [#1] SMP
[   28.846264] Modules linked in: mce_amd_inj amd64_edac_mod r8169


here's a sample mc0 error injected after applying both sets of changes 
to the code:
[   94.109090] [Hardware Error]: MC0 Error:
[   94.109103] fam_ops structure not alloc-ed. Cannot provide detailed 
family/model specific error decoding.
[   94.109119] [Hardware Error]: Error Status: Uncorrected, software 
containable error.
[   94.109132] [Hardware Error]: CPU:0 (15:30:0) 
MC0_STATUS[-|UE|-|-|-|-|-]: 0xa000000000010f0f
[   94.109146] [Hardware Error]: cache level: L3/GEN, mem/io: GEN, 
mem-tx: GEN, part-proc: GEN (timed out)


Shall I work up the patch with both sets of changes and resend?

Thanks,
-Aravind.

