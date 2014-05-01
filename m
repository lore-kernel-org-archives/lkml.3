Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbaEAHEY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 03:04:24 -0400
Received: from mx3.wp.pl ([212.77.101.9]:34485 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752796AbaEAHEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 03:04:22 -0400
Message-ID: <5361F1F3.7070005@wp.pl>
Date: Thu, 01 May 2014 09:04:19 +0200
From: Andrzej Hajda <andrzej.hajda@wp.pl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        open list <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>, Inki Dae <inki.dae@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Tomasz Stansislawski <t.stanislaws@samsung.com>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-samsung-soc@vger.kernel.org>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-arm-kernel@lists.infradead.org>,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC PATCH 0/4] drivers/base: Generic framework for tracking
 internal interfaces
References: <1398866574-27001-1-git-send-email-a.hajda@samsung.com> <20140430154914.GA898@kroah.com> <53616E31.3050404@wp.pl> <20140430222839.GE26756@n2100.arm.linux.org.uk>
In-Reply-To: <20140430222839.GE26756@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000009 [EUWF]                               
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux wrote, On 01.05.2014 00:28:
> On Wed, Apr 30, 2014 at 11:42:09PM +0200, Andrzej Hajda wrote:
>> The main problem with component framework is that componentization
>> significantly changes every driver and changes it in a way which is not
>> compatible with traditional drivers, so devices which are intended to
>> work with different DRM masters are hard to componentize if some of DRMs
>> are componentized and some not.
> Many of the problems which the component helpers are designed to solve
> are those where you need the drm_device structure (or snd_card, or whatever
> subsystem specific card/device representation structure) pre-created in
> order to initialise the components.
>
> In the case of DRM, you can't initialise encoders or connectors without
> their drm_device structure pre-existing - because these components are
> attached to the drm_device.
>
> Your solution to that is to delay those calls, but the DRM subsystem is
> not designed to cope like that - it's designed such that when the
> connector or encoder initialisation functions are called, it is assumed
> that the driver is initialising its state. (I've raised this point before
> but you've just fobbed it off in the past.)
>
> Another issue here is that the order of initialisation matters greatly.
> Take CRTCs for example.  In DRM, the order of attachment of CRTCs defines
> their identity, changing the order changes their identity, and changes
> how they are bound to their respective connectors.
>
The two problems you show here are not a real problems in this framework:
1. making real device initialization during drm initialization - 
decision is left
to driver developer what should be done in probe, what should be done in
'bind', I guess this is also true for components, at least the framework 
allows it.
2. initialization order - if you put initialization into components 
'bind' function,
master can choose any order of calls to 'bind'.

Anyway you can implement the same behaviour as components with
interface_tracker. Just simple proof of concept, how to convert 
componentized
drivers to interface_tracker:
Components:
1. you can reuse component_ops
2. You replace calls of component_add and component_del with calls
to interface_tracker_ifup(dev, INTERFACE_TRACKER_TYPE_COMPONENT, 
&specific_component_ops),
or interface_tracker_ifdown.
Thats all for components.

Master:
1. you register callback for tracking all components.
2. in the callback you check if all components are up, if yes you do the
same as in component framework initialization, to simplify it
helper function can be added.

I guess it should work the same way, if there is interest in it I can 
develop the
helper next week, I hope.

What is the benefit of interface_tracker:
1. interface_tracker is more generic - it can track not only components.
2. you put component initialization code into helper function - sounds 
like mid-layer removal,
developer can choose different helper if it suits better.

So from component point of view interface_tracker can be treated as kind 
of extensions
of the component framework.

I hope I have answerer all your concerns.

I have holidays till Sunday and I am not sure if I will be able to 
answer next emails before
Monday.

Regards
Andrzej
