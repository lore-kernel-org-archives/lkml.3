Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbaBRS13 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 13:27:29 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:58866 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751032AbaBRS11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 13:27:27 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.222;KIP:(null);UIP:(null);IPV:NLI;H:atltwp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VPS-5(zzbb2dI98dI9371Ie0eah1432I4015Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de097hz2dh839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1fe8h1ff5h209eh22d0h2336h2438h2461h2487h24ach24d7h2516h2545h255eh1155h)
X-WSS-ID: 0N17F9J-08-O01-02
X-M-MSG: 
Message-ID: <5303A607.7090309@amd.com>
Date: Tue, 18 Feb 2014 12:27:19 -0600
From: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: <dougthompson@xmission.com>, <linux-edac@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] EDAC, MCE, AMD: Fix code to prevent NULL dereference
References: <1392659391-2411-1-git-send-email-Aravind.Gopalakrishnan@amd.com> <20140217182729.GE4559@pd.tnic> <5302625C.4050700@amd.com> <20140217194153.GG4559@pd.tnic> <53028EE8.20106@amd.com> <20140218003654.GK4559@pd.tnic> <20140218084636.GA24465@pd.tnic>
In-Reply-To: <20140218084636.GA24465@pd.tnic>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/18/2014 2:46 AM, Borislav Petkov wrote:
> Ok, let's try a simpler thing. Only build-tested here:
>
>   
> +	if (!fam_ops)
> +		return NOTIFY_DONE;
> +
>   	if (amd_filter_mce(m))
>   		return NOTIFY_STOP;
>   
> @@ -816,10 +819,10 @@ static int __init mce_amd_init(void)
>   	struct cpuinfo_x86 *c = &boot_cpu_data;
>   
>   	if (c->x86_vendor != X86_VENDOR_AMD)
> -		return 0;
> +		return -ENODEV;
>   
>   	if (c->x86 < 0xf || c->x86 > 0x16)
> -		return 0;
> +		return -ENODEV;
>   
>   	fam_ops = kzalloc(sizeof(struct amd_decoder_ops), GFP_KERNEL);
>   	if (!fam_ops)
> @@ -874,6 +877,7 @@ static int __init mce_amd_init(void)
>   	default:
>   		printk(KERN_WARNING "Huh? What family is it: 0x%x?!\n", c->x86);
>   		kfree(fam_ops);
> +		fam_ops = NULL;
>   		return -EINVAL;
>   	}
>   
>

This works. But a drawback is that you wouldn't get the output from more 
generic error decoding that happens after the 'switch' in amd_decode_mce:

     pr_emerg(HW_ERR "Error Status: %s\n", decode_error_status(m))
     (etc..) (etc..)
     amd_decode_err_code(m->status & 0xffff);

A quick fix for this is to rearrange the above chunk of code to happen 
before the 'switch'
Tried it on local machine.Here's some sample outputs:

on unsupported h/w:
[   46.822828] [Hardware Error]: Error Status: Uncorrected, software 
containable error.
[   46.822846] [Hardware Error]: CPU:0 (15:30:0) 
MC0_STATUS[-|UE|-|-|-|-|-]: 0xa000000000010f0f
[   46.822858] [Hardware Error]: cache level: L3/GEN, mem/io: GEN, 
mem-tx: GEN, part-proc: GEN (timed out)

on supported h/w:(a MC0 error)
[   84.305292] [Hardware Error]: Error Status: Uncorrected, software 
containable error.
[   84.305312] [Hardware Error]: CPU:0 (15:30:0) 
MC0_STATUS[-|UE|-|-|-|-|-]: 0xa000000000010f0f
[   84.305327] [Hardware Error]: cache level: L3/GEN, mem/io: GEN, 
mem-tx: GEN, part-proc: GEN (timed out)
[   84.305343] [Hardware Error]: MC0 Error:  Internal error condition 
type 1.

on supported h/w:(a MC4 ECC error)
[  128.942878] [Hardware Error]: Error Status: System Fatal error.
[  128.942897] [Hardware Error]: CPU:0 (15:30:0) 
MC4_STATUS[-|UE|-|PCC|AddrV|-|-|UECC]: 0xa600200000080a23
[  128.942914] [Hardware Error]: MC4_ADDR: 0x0000000000000000
[  128.942922] [Hardware Error]: cache level: L3/GEN, mem/io: MEM, 
mem-tx: WR, part-proc: RES (no timeout)
[  128.942939] [Hardware Error]: MC4 Error (node 0): DRAM ECC error 
detected on the NB.
[  128.942971] EDAC MC0: 1 UE on mc#0csrow#2channel#0 (csrow:2 channel:0 
page:0x0 offset:0x0 grain:0)

A word about your earlier suggestion of using amd_notifier_call_chain in 
mce_amd_inj:
The changes will need to be more involved..
- Firstly, x86_mce_decoder_chain is defined in mce.c. So we'd need to 
move it to somewhere in asm/mce.h
- include notifier.h in asm/mce.h (build error saying there are multiple 
definitions of 'x86_mce_decoder_chain' when I tried this.. haven't 
figured out why yet..)
- You'd need to change i_mce to pointer type which in turn will need 
changes in the manner we reference the struct variables in the code

Not sure if you need these many changes, not to mention - touch common 
mce code.
Simpler solution might be to rearrange the code in amd_decode_mce and 
use your hunk..
Thoughts?

Thanks,
-Aravind.


