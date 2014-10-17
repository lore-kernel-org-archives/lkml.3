Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbaJQQOU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 12:14:20 -0400
Received: from mail-oi0-f44.google.com ([209.85.218.44]:61971 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490AbaJQQOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 12:14:19 -0400
Message-ID: <54414057.5020806@acm.org>
Date: Fri, 17 Oct 2014 11:14:15 -0500
From: Corey Minyard <minyard@acm.org>
Reply-To: minyard@acm.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Thomas Renninger <trenn@suse.de>, martin.wilck@ts.fujitsu.com
CC: linux-kernel@vger.kernel.org, openipmi-developer@lists.sourceforge.net
Subject: Re: [patch 1/3] ipmi: Setup ipmi_devintf automatically if ipmi_msghandler
 gets loaded
References: <20141014144020.683892494@d46.suse.de> <20141014144315.178850163@d46.suse.de> <543DCC4C.3090404@acm.org> <27197467.RMEiFLZMHQ@d46>
In-Reply-To: <27197467.RMEiFLZMHQ@d46>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2014 02:49 AM, Thomas Renninger wrote:
> Hi,
>
> On Tuesday, October 14, 2014 08:22:20 PM Corey Minyard wrote:
>> On 10/14/2014 09:40 AM, trenn@suse.de wrote:
>>> This removes the ipmi_devintf to be a module, but it will automatically
>>> compiled in if ipmi_msghandler is set.
>>>
>>> ipmi_msghandler module is renamed to ipmi_handler because of the name
>>> clash with the ipmi_msghandler.o object file (see Makefile for details).
>>> Alternatively ipmi_msghandler.c could be renamed to ipmi_handler.c, but
>>> not polluting git history should be more of an advantage than module
>>> renaming.
>>>
>>> cleanup_ipmi_dev() and init_ipmi_devintf() implemented in ipmi_devintf.c
>>> are are simply declared ipmi_msghandler.c without creating a separate
>>> header file which looks more reasonable to me. Hope that is ok.
>> One minor style issue: the function definitions should really be in a .h
>> file.
> Ok.
>
>> Renaming the module is also probably a bad idea.  If this was to go in,
>> it would certainly need to keep the ipmi_msghandler.ko name to avoid
>> complete breakage all over the place.
> ? What should break?
> It should never be needed to load ipmi_msghandler manually.
> Even if autoloading does not work, loading the low level
> serving driver (e.g. ipmi_si) is enough. This one will request
> ipmi_(msg)handler.ko automatically.
> I excpect this is the same for all other ipmi HW serving drivers, right?
>
>> In that vein, I am worried that this would just result in a lot of work
>> for all the distros that have set up this already.
> We also loaded the ipmi driver manually via the OpenIPMI init service
> which simply tried to load ipmi drivers.
> This results in boot load time, resource and code overhead.
> As ipmi autoload seem to work fine for recent HW these days, the userspace
> interface should load as well, otherwise the whole autoloading is more
> or less useless.

This is the kind of stuff I'm worried about.  If there are script that load
modules, they may be broken.  Module dependencies in modprobe.d
may be broken.  Things like that.

By changing a name you are, in effect, changing a user interface and
that should be done with extreme care.

>> I'm trying to see the pros and cons of
>> this, and I can't see that the pros outweigh the cons.  Do you have people
>> that have issues with this?
> Yes. In fact Fujitsu opened a bug for this. Unfortunately I cannot set it
> public as it is against SLES12. If I find a way, I'll reference it in
> the changelog:
> https://bugzilla.novell.com/show_bug.cgi?id=893181
> Subject:
> ipmi_devintf is not available when IPMI device is detected
>
> I already added Martin to CC: of the patch changelog, but quilt may
> not have recogized it and not added him to CC?
>
> Beside Fujitsu, I'd like to have this fixed as well.
> We adjust BMC settings via after install script on our servers via
> ipmitool. This does not work because of this bug.
> One has to:
> modprobe ipmi_devintf
> This is overhead and makes the whole autoloading mechanism useless.
> And even worse, ipmi_devintf seem to load on all machines whether they
> have an ipmi controller or not.
>
>
>>> In fact there already was a kind of autoloading mechanism (gets deleted
>>> with this patch). I interpret this line that ipmi_devintf should get
>>> autoloaded if ipmi_si gets loaded?:
>>> -MODULE_ALIAS("platform:ipmi_si");
>>>
>>> But:
>>>   - It's wrong: There are other low lever drivers which can be used by
>>>   
>>>     ipmi_devintf
>>>   
>>>   - It does not work (anymore?)
>>>   - There is no need to keep ipmi_devintf as a module (resource and load
>>>   time
>>>   
>>>     overhead)
>> This change is certainly a good idea.  Whatever it was trying to do is
>> wrong.
> Thanks. I am convinced that the right way to go for is to integrate the 
> ipmi_devintf into ipmi_msghandler.
>
> I see 3 options how to do this:
>   - rename ipmi_msghandler.ko to ipmi_handler.ko
>     As this only is an interface provider for other modules getting
>     loaded/requested automatically and never needs to be loaded manually
>     (pls correct me if I am wrong), I would like to go for this option.
>
>   - rename ipmi_msghandler.c to ipmi_handler.c
>     -> git history lost. But should still be seen via:
>     git log --follow?
>
>   - Someone finds another way how to modify the Makefile to achieve above.

How about this.  I did a little research, and there's something called soft
module dependencies.  Apparently you can add:

MODULE_SOFTDEP("post: ipmi_devintf")

to ipmi_msghandler.c and modprobe would load ipmi_devintf after loading
ipmi_msghandler if it was available.


-corey

> Thanks,
>
>      Thomas

