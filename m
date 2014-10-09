Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751398AbaJITBX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 15:01:23 -0400
Received: from mail-bn1bon0143.outbound.protection.outlook.com ([157.56.111.143]:23072
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751002AbaJITBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 15:01:14 -0400
X-WSS-ID: 0ND6Y5V-07-WTI-02
X-M-MSG: 
Message-ID: <5436DB72.1090507@amd.com>
Date: Thu, 9 Oct 2014 14:01:06 -0500
From: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: <slaoub@gmail.com>, Tony Luck <tony.luck@intel.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Fwd: [PATCH] x86, MCE, AMD: save IA32_MCi_STATUS before machine_check_poll()
 resets it
References: <1412037578.21488.11.camel@debian> <20140930072553.GA4639@pd.tnic>
 <1412070991.16556.12.camel@cyc> <20140930100940.GD4639@pd.tnic>
 <1412138102.21488.20.camel@debian> <20141002131206.GA16452@pd.tnic>
 <CAOjmkp9qQiTbqU3NUhUDAoQAa8wAPJnE_qXbDuBKrA3ee1_APQ@mail.gmail.com>
 <5435B206.60402@amd.com> <20141008225750.GH16892@pd.tnic>
 <20141009165339.GA11360@arav-dinar> <20141009173529.GC17647@pd.tnic>
In-Reply-To: <20141009173529.GC17647@pd.tnic>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(51704005)(52604005)(24454002)(479174003)(189002)(52314003)(2473001)(377454003)(199003)(31966008)(80022003)(4396001)(47776003)(46102003)(20776003)(84676001)(65816999)(65956001)(64706001)(65806001)(87266999)(50986999)(54356999)(83506001)(80316001)(44976005)(68736004)(23676002)(87936001)(110136001)(50466002)(107046002)(95666004)(106466001)(101416001)(105586002)(85306004)(93886004)(21056001)(85852003)(76482002)(97736003)(76176999)(59896002)(64126003)(102836001)(99396003)(92726001)(120916001)(33656002)(86362001)(92566001)(36756003);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB207;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB207;
X-Forefront-PRVS: 0359162B6D
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/9/2014 12:35 PM, Borislav Petkov wrote:
> On Thu, Oct 09, 2014 at 11:53:39AM -0500, Aravind Gopalakrishnan wrote:
>> How do you mean "last error"?
>> The interrupt is only fired upon overflow..
> And? Think about it, what is causing the overflow? A CE, right?
>
> There was even a call to machine_check_poll() there which we removed,
> but for another reason. In any case, you should have the error signature
> in the MCA banks of the last error causing the overflow, right?

Right. I was not arguing that we shouldn't. Just wasn't clear on what 
you meant.
Anyway, Thanks for clarifying.

> This is
> what I mean with last error.
>
> However(!),...
>
>> CE error if collected through polling gives proper decoding info. So,
>> why should this be any different for the same CE error for which an
>> interrupt is generated on crossing a threshold?
> ... we're currently using a special signature to signal the overflow
> with the K8_MCE_THRESHOLD_BASE thing. You simply report a special bank
> and this way you can tell userspace that this is an overflow error. I
> think that was the reason behind the software-defined banks.
>
> Now, we can also drop that and simply log a normal error but make sure
> MASK_OVERFLOW_HI is passed onto userspace so that it can see that the
> error is an overflow error. I.e., something like this:
>
>          mce_setup(&m);
> 	// rdmsrl(MSR_IA32_MCG_STATUS, m.mcgstatus); - not sure about this one - we're not looking at MCGSTATUS for CEs
That's right. Might as well remove it.

>          // rdmsrl(address, m.misc); - this MSR can be saved too as we're reading
> 	// the MISC register already.
>          rdmsrl(MSR_IA32_MCx_STATUS(bank), m.status);
>          m.bank = bank;
>          mce_log(&m);
>
> so in the end it'll be something like this:
>
> 	mce_setup(&m);
> 	m.misc = (high << 32) | low;
> 	rdmsrl(MSR_IA32_MCx_STATUS(bank), m.status);
> 	m.bank = bank;
>          mce_log(&m);
>
> so I'm still on the fence about what we want to do and am expecting
> arguments.

I actually agree with this approach. So no argument:)
> I like the last one more because it is simpler and tools
> don't need to know about the software-defined banks.
>

Thanks
-Aravind.

