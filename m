Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131AbaKCStL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 13:49:11 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:35966 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbaKCStH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 13:49:07 -0500
Date: Mon, 3 Nov 2014 10:49:03 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Alexander Graf <agraf@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Heiko Stuebner <heiko@sntech.de>, Lee Jones <lee.jones@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Romain Perier <romain.perier@gmail.com>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH v3 00/47] kernel: Add support for power-off handler call
 chain
Message-ID: <20141103184903.GB10558@roeck-us.net>
References: <1414425354-10359-1-git-send-email-linux@roeck-us.net>
 <20141103175935.GS27425@saruman>
 <20141103182213.GA10640@roeck-us.net>
 <20141103182829.GV27425@saruman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141103182829.GV27425@saruman>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020203.5457CE23.00B7,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 2
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

On Mon, Nov 03, 2014 at 12:28:29PM -0600, Felipe Balbi wrote:
> Hi,
> 
> On Mon, Nov 03, 2014 at 10:22:13AM -0800, Guenter Roeck wrote:
> > On Mon, Nov 03, 2014 at 11:59:35AM -0600, Felipe Balbi wrote:
> > > Hi,
> > > 
> > > On Mon, Oct 27, 2014 at 08:55:07AM -0700, Guenter Roeck wrote:
> > > > Various drivers implement architecture and/or device specific means to
> > > > remove power from the system.  For the most part, those drivers set the
> > > > global variable pm_power_off to point to a function within the driver.
> > > > 
> > > > This mechanism has a number of drawbacks.  Typically only one means
> > > > to remove power is supported (at least if pm_power_off is used).
> > > > At least in theory there can be multiple means to remove power, some of
> > > > which may be less desirable.  For example, one mechanism might power off the
> > > > entire system through an I/O port or gpio pin, while another might power off
> > > > a board by disabling its power controller. Other mechanisms may really just
> > > > execute a restart sequence or drop into the ROM monitor, or put the CPU into
> > > > sleep mode.  Using pm_power_off can also be racy if the function pointer is
> > > > set from a driver built as module, as the driver may be in the process of
> > > > being unloaded when pm_power_off is called.  If there are multiple power-off
> > > > handlers in the system, removing a module with such a handler may
> > > > inadvertently reset the pointer to pm_power_off to NULL, leaving the system
> > > > with no means to remove power.
> > > > 
> > > > Introduce a system power-off handler call chain to solve the described
> > > > problems.  This call chain is expected to be executed from the architecture
> > > > specific machine_power_off() function.  Drivers providing system power-off
> > > > functionality are expected to register with this call chain.  By using the
> > > > priority field in the notifier block, callers can control power-off handler
> > > > execution sequence and thus ensure that the power-off handler with the
> > > > optimal capabilities to remove power for a given system is called first.
> > > > A call chain instead of a single call to the highest priority handler is
> > > > used to provide fallback: If multiple power-off handlers are installed,
> > > > all handlers will be called until one actually succeeds to power off the
> > > > system.
> > > > 
> > > > Patch 01/47 implements the power-off handler API.
> > > > 
> > > > Patches 02/47 to 04/47 are cleanup patches to prepare for the move of
> > > > pm_power_off to a common location.
> > > > 
> > > > Patches 05/47 to 07/47 remove references to pm_power_off from devicetree
> > > > bindings descriptions.
> > > > 
> > > > Patch 08/47 moves the pm_power_off variable from architecture code to
> > > > kernel/reboot.c. 
> > > > 
> > > > Patches 09/47 to 34/47 convert various drivers to register with the kernel
> > > > power-off handler instead of setting pm_power_off directly.
> > > > 
> > > > Patches 35/47 to 46/47 do the same for architecture code.
> > > > 
> > > > Patch 47/47 finally removes pm_power_off.
> > > > 
> > > > For the most part, the individual patches include explanations why specific
> > > > priorities were chosen, at least if the selected priority is not the default
> > > > priority. Subsystem and architecture maintainers are encouraged to have a look
> > > > at the selected priorities and suggest improvements.
> > > > 
> > > > I ran the final code through my normal build and qemu tests. Results are
> > > > available at http://server.roeck-us.net:8010/builders in the 'poweroff-handler'
> > > > column. I also built all available configurations for arm, mips, powerpc,
> > > > m68k, and sh architectures.
> > > > 
> > > > The series is available in branch poweroff-handler of my repository at
> > > > git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git.
> > > > It is based on 3.18-rc2.
> > > > 
> > > > A note on Cc: In the initial submission I had way too many Cc:, causing the
> > > > patchset to be treated as spam by many mailers and mailing list handlers,
> > > > which of course defeated the purpose. This time around I am cutting down
> > > > the distribution list down significantly. My apologies to anyone I may have
> > > > failed to copy this time around.
> > > 
> > > you touch every single architecture with this patchset, but you didn't
> > > care about Ccing any of the arch-specific mailing lists, like lakml ?
> > > 
> > What is lakml ? linux-kernel@vger.kernel.org was copied, if that is what you
> 
> only the greatest mailing list of all time.
> 
> heh, Linux ARM Kernel Mailing List.
> 

Similar to linux-omap, linux-arm-kernel was copied on individual patches
if get_maintainer.pl suggested it. I'll be happy to add both lists manually
to the entire series for the next version of the patch set if the respective
maintainers (Tony and Russell) ask me to do so.

Note that this doesn't mean that the patches will actually be accepted by
those lists, especially if the lists are moderated for non-subscribers.

Guenter
