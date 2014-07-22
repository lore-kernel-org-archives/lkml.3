Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910AbaGVILY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 04:11:24 -0400
Received: from mail-bn1blp0186.outbound.protection.outlook.com ([207.46.163.186]:5114
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753227AbaGVILT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 04:11:19 -0400
X-WSS-ID: 0N93TEJ-08-8RE-02
X-M-MSG: 
Message-ID: <53CE1C92.2070200@amd.com>
Date: Tue, 22 Jul 2014 11:10:58 +0300
From: Oded Gabbay <oded.gabbay@amd.com>
Organization: AMD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jerome Glisse <j.glisse@gmail.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        =?ISO-8859-1?Q?Michel_D=E4nzer?= <michel.daenzer@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        linux-mm <linux-mm@kvack.org>,
        "Alexey Skidanov" <Alexey.Skidanov@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Bridgman, John" <John.Bridgman@amd.com>,
        "Dave Airlie" <airlied@redhat.com>,
        =?ISO-8859-1?Q?Christian_K=F6nig?= <christian.koenig@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Daniel Vetter <daniel@ffwll.ch>,
        "Sellek, Tom" <Tom.Sellek@amd.com>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>
Subject: Re: [PATCH v2 00/25] AMDKFD kernel driver
References: <20140720174652.GE3068@gmail.com> <53CD0961.4070505@amd.com>
 <53CD17FD.3000908@vodafone.de> <53CD1FB6.1000602@amd.com>
 <20140721155437.GA4519@gmail.com> <53CD5122.5040804@amd.com>
 <20140721181433.GA5196@gmail.com> <53CD5DBC.7010301@amd.com>
 <20140721185940.GA5278@gmail.com> <53CD68BF.4020308@amd.com>
 <20140722072337.GG15237@phenom.ffwll.local>
In-Reply-To: <20140722072337.GG15237@phenom.ffwll.local>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(24454002)(51704005)(479174003)(189002)(199002)(50986999)(21056001)(46102001)(85852003)(101416001)(81542001)(107886001)(80316001)(65816999)(107046002)(65806001)(47776003)(97736001)(92726001)(44976005)(2201001)(87936001)(86362001)(80022001)(92566001)(81342001)(83072002)(65956001)(4396001)(79102001)(36756003)(20776003)(64706001)(76482001)(77982001)(83322001)(76176999)(74502001)(561944003)(31966008)(68736004)(74662001)(93886003)(106466001)(83506001)(85306003)(84676001)(102836001)(54356999)(87266999)(50466002)(64126003)(99396002)(33656002)(95666004)(105586002)(23756003)(1121002)(921003);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR02MB033;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02801ACE41
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/07/14 10:23, Daniel Vetter wrote:
> On Mon, Jul 21, 2014 at 10:23:43PM +0300, Oded Gabbay wrote:
>> But Jerome, the core problem still remains in effect, even with your
>> suggestion. If an application, either via userspace queue or via ioctl,
>> submits a long-running kernel, than the CPU in general can't stop the
>> GPU from running it. And if that kernel does while(1); than that's it,
>> game's over, and no matter how you submitted the work. So I don't really
>> see the big advantage in your proposal. Only in CZ we can stop this wave
>> (by CP H/W scheduling only). What are you saying is basically I won't
>> allow people to use compute on Linux KV system because it _may_ get the
>> system stuck.
>>
>> So even if I really wanted to, and I may agree with you theoretically on
>> that, I can't fulfill your desire to make the "kernel being able to
>> preempt at any time and be able to decrease or increase user queue
>> priority so overall kernel is in charge of resources management and it
>> can handle rogue client in proper fashion". Not in KV, and I guess not
>> in CZ as well.
>
> At least on intel the execlist stuff which is used for preemption can be
> used by both the cpu and the firmware scheduler. So we can actually
> preempt when doing cpu scheduling.
>
> It sounds like current amd hw doesn't have any preemption at all. And
> without preemption I don't think we should ever consider to allow
> userspace to directly submit stuff to the hw and overload. Imo the kernel
> _must_ sit in between and reject clients that don't behave. Of course you
> can only ever react (worst case with a gpu reset, there's code floating
> around for that on intel-gfx), but at least you can do something.
>
> If userspace has a direct submit path to the hw then this gets really
> tricky, if not impossible.
> -Daniel
>

Hi Daniel,
See the email I just sent to Jerome regarding preemption. Bottom line, in KV, we 
can preempt running queues, except from the case of a stuck gpu kernel. In CZ, 
this was solved.

So, in this regard, I don't think there is any difference between userspace 
queues and ioctl.

	Oded
