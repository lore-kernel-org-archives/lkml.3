Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419AbaJBPXa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 11:23:30 -0400
Received: from mail-bn1bon0116.outbound.protection.outlook.com ([157.56.111.116]:5280
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754367AbaJBPX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 11:23:27 -0400
X-WSS-ID: 0NCTPEU-07-MKU-02
X-M-MSG: 
Message-ID: <542D6DE5.3000205@amd.com>
Date: Thu, 2 Oct 2014 10:23:17 -0500
From: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: <bhelgaas@google.com>, <linux-pci@vger.kernel.org>, <tglx@linutronix.de>,
        <hpa@zytor.com>, <x86@kernel.org>, <bp@suse.de>,
        <dan.carpenter@oracle.com>, <dougthompson@xmission.com>,
        <m.chehab@samsung.com>, <linux-edac@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] edac, amd64_edac: Add F15h M60h support
References: <1411070230-10298-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
 <20141001113235.GC18271@pd.tnic> <542C5995.7050803@amd.com>
 <20141002145201.GF16452@pd.tnic>
In-Reply-To: <20141002145201.GF16452@pd.tnic>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(24454002)(51704005)(479174003)(377454003)(199003)(164054003)(189002)(33656002)(120916001)(23676002)(59896002)(85852003)(110136001)(80022003)(99396003)(86362001)(120886001)(10300001)(92726001)(44976005)(68736004)(102836001)(76482002)(46102003)(20776003)(80316001)(87936001)(101416001)(97736003)(93886004)(85306004)(47776003)(21056001)(31966008)(64706001)(83506001)(50466002)(84676001)(54356999)(95666004)(76176999)(36756003)(65816999)(106466001)(65956001)(4396001)(92566001)(87266999)(107046002)(65806001)(105586002)(50986999)(64126003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB203;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB203;
X-Forefront-PRVS: 03524FBD26
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB428;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/2/2014 9:52 AM, Borislav Petkov wrote:
> On Wed, Oct 01, 2014 at 02:44:21PM -0500, Aravind Gopalakrishnan wrote:
>> The more I think about this, I'm finding it's hard to do this cleanly.
>> I initially thought I'd just cache this in pvt->dram_type the first time I'm
>> doing this.
>> But, the pvt->ops->dbam_to_cs() mappers get called first before
>> determine_memory_type().
>>
>> So, If I look for dram_type in f15_m60h_dbam_to_chip_select() it's ugly as
>> that's really the point of
>> having a determine_memory_type().
>>
>> Also, there's just a lot of if-else statements in determine_memory_type()
>> now.
>> This could benefit from having a per-family low_ops function.
>> And, we can call this early... somewhere in read_mc_regs() so that we have
>> information ready to use in
>> f15_m60h_dbam_to_chip_select() and in init_csrows() which needs dram_type
>> too.
> Right, this is what I was thinking too: somewhere in read_mc_regs(),
> after having collected ->dclr0, you call determine_memory_type() and
> store it into pvt->dram_type.

Yep.
So, let me go ahead and make these changes.
Shall send out a V2 once I have an answer on the LRDIMM question..

Thanks,
-Aravind.

>> Oh, btw- We can do away with a pvt->dram_ctrl as
>> f15_m60h_dbam_to_chip_select() really just needs the dram_type.
> Yes, you make the read of DRAM_CONTROL inside determine_memory_type() as
> we don't need it anywhere else.
>
> If we do, all of a sudden, we'll move it up to read_mc_regs(). IOW, I'm
> trying to centralize all reg reads in read_mc_regs() and use locally
> cached info later so I don't have to access the hardware each time
> needlessly, if it can be helped.
>
>


