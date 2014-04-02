Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130AbaDBNG6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 09:06:58 -0400
Received: from mail-am1lp0014.outbound.protection.outlook.com ([213.199.154.14]:33780
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932097AbaDBNG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 09:06:57 -0400
X-Greylist: delayed 844 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Apr 2014 09:06:56 EDT
Message-ID: <533C081D.9050202@mellanox.com>
Date: Wed, 2 Apr 2014 15:52:45 +0300
From: Haggai Eran <haggaie@mellanox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Jerome Glisse <j.glisse@gmail.com>
CC: Andrea Arcangeli <aarcange@redhat.com>,
        Mike Rapoport <mike.rapoport@ravellosystems.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Or Gerlitz <ogerlitz@mellanox.com>, Sagi Grimberg <sagig@mellanox.com>,
        Shachar Raindel <raindel@mellanox.com>
Subject: Re: [PATCH] mm/mmu_notifier: restore set_pte_at_notify semantics
References: <1389778834-21200-1-git-send-email-mike.rapoport@ravellosystems.com> <20140122131046.GF14193@redhat.com> <52DFCF2B.1010603@mellanox.com> <20140330203328.GA4859@gmail.com>
In-Reply-To: <20140330203328.GA4859@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [46.120.107.62]
X-ClientProxiedBy: AMSPR05CA010.eurprd05.prod.outlook.com (10.242.77.168) To
 DB3PR05MB073.eurprd05.prod.outlook.com (10.255.251.151)
X-Forefront-PRVS: 0169092318
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019001)(6009001)(6049001)(428001)(189002)(199002)(377454003)(51704005)(479174003)(24454002)(76482001)(66066001)(47776003)(54356001)(20776003)(42186004)(87976001)(63696002)(76796001)(76786001)(65806001)(80022001)(65956001)(77096001)(31966008)(47446002)(74502001)(53806001)(15202345003)(99396002)(54316002)(74662001)(81342001)(56776001)(81542001)(83506001)(23756003)(69226001)(85306002)(19580395003)(83322001)(80316001)(15975445006)(64126003)(97336001)(83072002)(97186001)(85852003)(81686001)(90146001)(95416001)(77982001)(59766001)(4396001)(50986001)(74876001)(49866001)(59896001)(56816005)(47736001)(80976001)(93136001)(92726001)(92566001)(74366001)(93516002)(46102001)(81816001)(50466002)(36756003)(95666003)(51856001)(98676001)(74706001)(94946001)(47976001)(33656001)(86362001)(79102001)(94316002)(3076001);DIR:OUT;SFP:1102;SCL:1;SRVR:DB3PR05MB073;H:[192.168.0.93];FPR:FE76C1DC.9F265E29.33E5BF93.6C1CC4A.20304;MLV:nov;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: Mellanox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2014 11:33 PM, Jerome Glisse wrote:
> On Wed, Jan 22, 2014 at 04:01:15PM +0200, Haggai Eran wrote:
>> I'm worried about the following scenario:
>>
>> Given a read-only page, suppose one host thread (thread 1) writes to
>> that page, and performs COW, but before it calls the
>> mmu_notifier_invalidate_page_if_missing_change_pte function another host
>> thread (thread 2) writes to the same page (this time without a page
>> fault). Then we have a valid entry in the secondary page table to a
>> stale page, and someone (thread 3) may read stale data from there.
>>
>> Here's a diagram that shows this scenario:
>>
>> Thread 1                                | Thread 2        | Thread 3
>> ========================================================================
>> do_wp_page(page 1)                      |                 |
>>    ...                                   |                 |
>>    set_pte_at_notify                     |                 |
>>    ...                                   | write to page 1 |
>>                                          |                 | stale access
>>    pte_unmap_unlock                      |                 |
>>    invalidate_page_if_missing_change_pte |                 |
>>
>> This is currently prevented by the use of the range start and range end
>> notifiers.
>>
>> Do you agree that this scenario is possible with the new patch, or am I
>> missing something?
>>
> I believe you are right, but of all the upstream user of the mmu_notifier
> API only xen would suffer from this ie any user that do not have a proper
> change_pte callback can see the bogus scenario you describe above.
Yes. I sent our RDMA paging RFC patch-set on linux-rdma [1] last month, 
and it would also suffer from this scenario, but it's not upstream yet.
> The issue i see is with user that want to/or might sleep when they are
> invalidation the secondary page table. The issue being that change_pte is
> call with the cpu page table locked (well at least for the affected pmd).
>
> I would rather keep the invalidate_range_start/end bracket around change_pte
> and invalidate page. I think we can fix the kvm regression by other means.
Perhaps another possibility would be to do the 
invalidate_range_start/end bracket only when the mmu_notifier is missing 
a change_pte implementation.

Best regards,
Haggai

[1] http://www.spinics.net/lists/linux-rdma/msg18906.html
