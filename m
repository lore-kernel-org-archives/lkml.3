Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760830AbaGSKTZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 06:19:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33743 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757989AbaGSKTW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 06:19:22 -0400
Message-ID: <53CA4608.3040208@redhat.com>
Date: Sat, 19 Jul 2014 12:18:48 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>,
        =?ISO-8859-1?Q?Antoine_T=E9nart?= 
	<antoine.tenart@free-electrons.com>
CC: sebastian.hesselbarth@gmail.com, kishon@ti.com,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-ide@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 0/8] ARM: berlin: add AHCI support
References: <1405686607-8126-1-git-send-email-antoine.tenart@free-electrons.com> <20140718135758.GB13012@htj.dyndns.org>
In-Reply-To: <20140718135758.GB13012@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 07/18/2014 03:57 PM, Tejun Heo wrote:
> (cc'ing Hans who's now maintaining libahci-platform.)

Note I was already following this thread as I'm subscribed to
linux-ide now.

>
> On Fri, Jul 18, 2014 at 02:29:59PM +0200, Antoine Ténart wrote:
>> Tejun, Kishon, Sebastian,
>>
>> I looked into the AHCI framework to see how to map PHYs and ports
>> information. I see two ways of doing this:
>>    - We can attach the ahci_port_priv to the ahci_host_priv structure,
>>      but that would require quite a lot of changes since the
>>      ahci_port_priv is initialized at the very end (in port_start()) and
>>      because ahci_port_priv is currently retrieved from the ata_port
>>      structure in libahci functions. We do want to parse the dt ports
>>      early in the AHCI initialization to be able to generate the right
>>      port_map mask. Tests would be needed to ensure nothing is broken.
>>    - We can move the PHY handling to where the ports are handled, moving
>>      PHYs from ahci_host_priv to ahci_port_priv. This also would require
>>      to perform some tests as PHY operations would be moved from
>>      libahci_platform to libahci.
>
> I don't get the last part.  Why would it have to be moved from
> libahci_platform to libahci?  Can't we break up the init steps so that
> PHY handling can be put inbetween?  The last time I suggested that,
> Hans seemed to agree.

Yes as it sounded good, but I did not look at the code to closely,
looking closer at the code I can see the problem.

ahci_port_priv gets allocated from ahci_port_start in
libahci.c and that same function also starts the port.

If we want to store the phy in ahci_port_priv then we need to do
some work between ahci_port_priv getting allocated and the port getting
started.

ahci_port_start gets allocated from ata_host_start, with the relevant
bit being:

         for (i = 0; i < host->n_ports; i++) {
                 struct ata_port *ap = host->ports[i];

                 if (ap->ops->port_start) {
                         rc = ap->ops->port_start(ap);


We could move the allocating of ahci_port_priv to libahci.c:
ahci_init_controller() which has a similar loop. But then the
ahci_port_priv info still is allocated after we call
ahci_platform_enable_resources()

The problem is that:

1) We need to enable resources before we can do ahci_save_initial_config()
2) We must do ahci_save_initial_config() before we can do ata_host_alloc_pinfo()
3) Therefor we don't have port_info at enable_resources time, which is when we
want to enable the phys (and we cannot just enable the phys elsewhere as
enable_resouces gets used on e.g. resume too).

So I think it is best to just make the phy pointers an array inside
ahci_host_priv, with a comment that the array indexes must match port
indexes. Which brings us back to square one, sorry for long dance to
get there.

I know I initially agreed that it would be good to store the phy
pointer inside ahci_port_priv, but in practice this just does not
work well as we get and enable resources before we have ahci_port_priv.
Which I see is exactly what you've done in patch 4 of v10 of this
series :)

>> In both cases we do not have time to do this for the next release, as
>> the request popped up quite late.
>>
>> So as of now:
>>    - Either the series is merged as is and changes to the AHCI framework
>>      can be made for 3.18, as it's not particularly linked to this
>>      series.
>>    - Or you really do not want it. Then that would be great if patches
>>      1-2 and 7-8 could be merged so that we do not end up with this big
>>      series going for yet another cycle... I think Kishon already took
>>      patches 1-2.
>
> I don't wanna take in code which isn't in the shape that it should be.
> Things like this accumulate to become a large maintenance burden over
> time.  Sure, urgent things can slip in and then later be fixed up but
> who are gonna do that here?  You guys already seem to be under time
> pressure as it is.
>
> If you guys can figure something out with Hans regarding how to
> proceed on this, I'll be happy take the code as is.

I think the way to proceed with this is just leaving things as they are,
see above.

As for taking the ahci parts of this series, except for the minor comments
from you to patch 3 and from me to patch 5 that is fine with me.

Regards,

Hans


>
> Thanks.
>
