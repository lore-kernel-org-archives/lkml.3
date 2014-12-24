Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783AbaLXJ2T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 04:28:19 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:4726 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbaLXJ2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 04:28:15 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 24 Dec 2014 01:26:32 -0800
Message-ID: <549A8710.8090901@nvidia.com>
Date: Wed, 24 Dec 2014 01:27:44 -0800
From: Bill Huang <bilhuang@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Bibek Basu <bibekbasu@gmail.com>
CC: Grant Likely <grant.likely@linaro.org>, <vinceh@nvidia.com>,
        <linux-kernel@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [RFC 1/1] driver core: re-order dpm_list after a succussful probe
References: <1418385015-26811-1-git-send-email-bilhuang@nvidia.com> <20141212153402.GA4746@kroah.com> <CAJc=co_s7yriw0baBH+w-_KFCyWSpX=6BY_qT2E2yUke6i9ohw@mail.gmail.com> <54928AE4.3030901@nvidia.com> <CAJc=co8uWqZ_6VL4X+tVrszA1aty6hga3c6BE1b6ufZRhMtwGQ@mail.gmail.com>
In-Reply-To: <CAJc=co8uWqZ_6VL4X+tVrszA1aty6hga3c6BE1b6ufZRhMtwGQ@mail.gmail.com>
X-Originating-IP: [10.19.108.109]
X-ClientProxiedBy: HKMAIL102.nvidia.com (10.18.16.11) To
 HKMAIL104.nvidia.com (10.18.16.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/23/2014 10:26 PM, Bibek Basu wrote:
> sorry for the delay in responding.
>
> On Thu, Dec 18, 2014 at 1:35 PM, Bill Huang <bilhuang@nvidia.com
> <mailto:bilhuang@nvidia.com>> wrote:
>
>
>
>     On 12/17/2014 10:47 PM, Bibek Basu wrote:
>
>         Hi Bill,
>
>         Though I like your solution, I have a usecase where the driver probe
>         sequence itself is not right. Both the driver are module_init
>         but one
>         depends on another during suspend sequence.
>         In such a situation, my system hangs. What do you suggest to do
>         in that
>         case? Should I get my driver registration sequence right and how?
>         Moving tegra-pcie driver above in the probe sequence by making the
>         driver subsystem_initcall solved the issue I am facing with this
>         patch.
>         But I don't think that's  allowed solution?
>
>
>     To change the probe sequence, use defer probe is the right choice.
>
> What if there is no direct dependency to defer probe ?

In your example, tegra-pcie driver doesn't have init dependency against 
pcieport but do have pm suspend dependency in between the two. Though 
I'm not familiar with pcie driver framework but it sounds like pcieport 
driver is framework driver so it might not be able to know/expect there 
will be "tegra-pcie" driver been probed later, that means defer probe 
cannot be used to resolve the pm sequence.

If suspend function of tegra-pcie driver cannot be hooked to pcieport 
driver (so it won't hang while pcieport is suspending) and explicitly to 
be called to suspend after pcieport driver has done all its access to 
the controller then I personally think moving tegra-pcie to 
subsystem_initcall is an acceptable fix, but I'm not expert of the pm 
design so maybe there is some other proper fix...
>
>
>
>         Example:
>
>         Probe sequence:
>         driver pcieport
>         driver tegra-pcie
>
>         Due to your patch, suspend_noirq for tegra_pcie will be called
>         before
>
>
>     Are you sure? My change will only affect pm devices in dpm_list,
>     suspend_noirq should still be called after all devices in dpm_list
>     were suspended.
>
> Yes, all lists are affected if you update dpm_list. Because using
>   dpm_list, dm_prepared_list is prepared . During suspend, using
> dpm_prepared_list, dpm_suspended_list is prepared. And using
> dpc_suspended_list, in dpm_suspend_late, dpm_late_early_list is prepared
> and which is used to call suspend_noirq callbacks and also prepare
> dpm_noirq_list. So all are related!!!
>
True they are all related and if both pcieport and tegra-pcie have 
suspend_noirq callback defined (I guess so since you said you have 
problem here:), then my fix will change the suspend sequence of the two.

This is my main reason to send this RFC since it could break a lot of 
existing working pm sequence.
>
>         pcieport. While pcieport tries to read through
>         pci_bus_read_config_dword
>         with clocks and power off to the pcie controller and eventually
>         leads to
>         a crash.
>
>
>
>         regards
>         Bibek
>
>         On Fri, Dec 12, 2014 at 9:04 PM, Greg KH
>         <gregkh@linuxfoundation.org <mailto:gregkh@linuxfoundation.org>
>         <mailto:gregkh@__linuxfoundation.org
>         <mailto:gregkh@linuxfoundation.org>>> wrote:
>
>              On Fri, Dec 12, 2014 at 03:50:15AM -0800, Bill Huang wrote:
>               > The dpm_list was added in the call "device_add" and when
>         we do defer
>               > probe we'll explicitly move the probed device to be the
>         last in the
>               > dpm_list, we should do the same for the normal probe
>         since there are
>               > cases that we won't have chance to do defer probe to
>         change the
>              PM order
>               > as the below example.
>               >
>               > If we would like the device driver A to be suspended
>         earlier than the
>               > device driver B, we won't have chance to do defer probe
>         to fix the
>               > suspend dependency since at the time device driver A is
>         probed,
>              device B
>               > was up and running.
>               >
>               > Device A was added
>               > Device B was added
>               > Driver for device B was binded
>               > Driver for device A was binded
>               >
>               > Signed-off-by: Bill Huang <bilhuang@nvidia.com
>         <mailto:bilhuang@nvidia.com>
>              <mailto:bilhuang@nvidia.com <mailto:bilhuang@nvidia.com>>>
>
>               > ---
>               >
>               > It seems to me this is a bug in the core driver, but I'm
>         not sure
>              how should
>               > we fix it.
>               >
>               > - Do we have better fix?
>               > - This proposed fix or any other fix might introduces
>         side effect
>              that breaks
>               >   existing working suspend dependencies which happen to work
>              based on the
>               >   existing wrong suspend order.
>               >
>               > Any thoughts? Thanks.
>               >
>               >  drivers/base/dd.c | 4 ++++
>               >  1 file changed, 4 insertions(+)
>               >
>               > diff --git a/drivers/base/dd.c b/drivers/base/dd.c
>               > index cdc779c..54886d2 100644
>               > --- a/drivers/base/dd.c
>               > +++ b/drivers/base/dd.c
>               > @@ -308,6 +308,10 @@ static int really_probe(struct
>         device *dev,
>              struct device_driver *drv)
>               >                       goto probe_failed;
>               >       }
>               >
>               > +     device_pm_lock();
>               > +     device_pm_move_last(dev);
>               > +     device_pm_unlock();
>               > +
>               >       driver_bound(dev);
>               >       ret = 1;
>               >       pr_debug("bus: '%s': %s: bound device %s to driver
>         %s\n",
>
>
>              Adding Grant, as he did the deferred probe stuff...
>
>              And it's the middle of the merge window, I'll not have time
>         to look at
>              this for a few weeks at the earliest, sorry.
>
>              thanks,
>
>              greg k-h
>              --
>              To unsubscribe from this list: send the line "unsubscribe
>              linux-kernel" in
>              the body of a message to majordomo@vger.kernel.org
>         <mailto:majordomo@vger.kernel.org>
>              <mailto:majordomo@vger.kernel.__org
>         <mailto:majordomo@vger.kernel.org>>
>              More majordomo info at
>         http://vger.kernel.org/__majordomo-info.html
>         <http://vger.kernel.org/majordomo-info.html>
>              Please read the FAQ at http://www.tux.org/lkml/
>
