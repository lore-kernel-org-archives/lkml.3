Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932475AbaITAR0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 20:17:26 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:47043 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756709AbaITARZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 20:17:25 -0400
Message-ID: <541CC721.2010207@roeck-us.net>
Date: Fri, 19 Sep 2014 17:15:29 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anish Bhatt <anish@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Subject: Re: linux-next: Tree for Sep 19
References: <20140919165817.225eb8b8@canb.auug.org.au> <20140919211404.GA24856@roeck-us.net> <541CAC81.9040404@infradead.org>
In-Reply-To: <541CAC81.9040404@infradead.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020209.541CC794.00A0,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 4
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2014 03:21 PM, Randy Dunlap wrote:
> On 09/19/14 14:14, Guenter Roeck wrote:
>> On Fri, Sep 19, 2014 at 04:58:17PM +1000, Stephen Rothwell wrote:
>>> Hi all,
>>>
>>> Changes since 20140917:
>>>
>>> The fsl tree still had its build failure so I used the version from
>>> next-20140917.
>>>
>>> The v4l-dvb tree lost its build failure.
>>>
>>> The security tree gained a conflict against the file-locks tree.
>>>
>>> Non-merge commits (relative to Linus' tree): 6014
>>>   5488 files changed, 217522 insertions(+), 129375 deletions(-)
>>>
>>> ----------------------------------------------------------------------------
>>>
>> Guess this is most difficult one.
>>
>> mips:nlm_xlp_defconfig:
>>
>> warning: (SCSI_BNX2X_FCOE && LIBFCOE && TCM_QLA2XXX) selects LIBFC which has
>> unmet direct dependencies (SCSI_LOWLEVEL && SCSI && SCSI_FC_ATTRS)
>> warning: (SCSI_BNX2X_FCOE && LIBFCOE && TCM_QLA2XXX) selects LIBFC which has
>> unmet direct dependencies (SCSI_LOWLEVEL && SCSI && SCSI_FC_ATTRS)
>
> Yes, I have a patch sitting on my hard drive that makes LIBFCOE and TCM_QLA2XXX
> and SCSI_BNX2X_FCOE depend on SCSI_FC_ATTRS, but I'm not entirely happy about
> having to hunt these down (even with the help of kconfig warnings).
>

One key problem is that nlm_xlp_defconfig does not configure NET anymore.
this is after 'scsi_netlink : Make SCSI_NETLINK dependent on NET instead
of selecting NET' was applied.

In fact, there are many more affected configurations; the change from
"select XXX" to "depends XXX" has far reaching consequences, as many
configurations are no longer valid. For mips alone I find that this commit
changes the following configurations.

e55_defconfig
gpr_defconfig
ip27_defconfig
jazz_defconfig
loongson3_defconfig
malta_defconfig
malta_kvm_defconfig
malta_kvm_guest_defconfig
mtx1_defconfig
nlm_xlp_defconfig
nlm_xlr_defconfig
rm200_defconfig

e55_defconfig is almost the same as before, but only because CONFIG_NET
was not configured for it to start with. For all others, CONFIG_NET is
no longer set. This effectively means that out of 55 mips configurations,
11 or 20% are now bad. This is 3.17-rc5. vs. next-20140919.

Frankly, I don't think this change was really helpful. On the contrary,
we will be in a lot of trouble when this change makes it upstream.
It might be be a good idea to be much more careful when making such
changes. Cleaning up configuration dependencies is a laudable goal,
but when it breaks configurations all over the place it does more damage
than it is worth.

Guenter

