Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751772AbaGGVbU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 17:31:20 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:60995 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750979AbaGGVbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 17:31:18 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Jani Nikula <jani.nikula@linux.intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Imre Deak <imre.deak@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: linux-next: Tree for Jun 19 (drm/i915)
Date: Mon, 07 Jul 2014 23:49:22 +0200
Message-ID: <3679297.SZvlmAxc8S@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140707200659.GL5821@phenom.ffwll.local>
References: <20140619161632.58b442e4@canb.auug.org.au> <16952236.GFHaOHoKy4@vostro.rjw.lan> <20140707200659.GL5821@phenom.ffwll.local>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 07, 2014 10:06:59 PM Daniel Vetter wrote:
> On Mon, Jul 07, 2014 at 10:01:27PM +0200, Rafael J. Wysocki wrote:
> > On Monday, July 07, 2014 04:54:23 PM Daniel Vetter wrote:
> > > On Wed, Jun 25, 2014 at 01:01:36AM +0200, Rafael J. Wysocki wrote:
> > > > On Tuesday, June 24, 2014 02:43:02 PM Jani Nikula wrote:
> > > > > On Thu, 19 Jun 2014, Randy Dunlap <rdunlap@infradead.org> wrote:
> > > > > > On 06/18/14 23:16, Stephen Rothwell wrote:
> > > > > >> Hi all,
> > > > > >> 
> > > > > >> The powerpc allyesconfig is again broken more than usual.
> > > > > >> 
> > > > > >> Changes since 20140618:
> > > > > >> 
> > > > > >
> > > > > > on i386:
> > > > > >
> > > > > > CONFIG_ACPI is not enabled.
> > > > > >
> > > > > >   CC      drivers/gpu/drm/i915/i915_drv.o
> > > > > > ../drivers/gpu/drm/i915/i915_drv.c: In function 'i915_drm_freeze':
> > > > > > ../drivers/gpu/drm/i915/i915_drv.c:547:2: error: implicit declaration of function 'acpi_target_system_state' [-Werror=implicit-function-declaration]
> > > > > > ../drivers/gpu/drm/i915/i915_drv.c:547:36: error: 'ACPI_STATE_S3' undeclared (first use in this function)
> > > > > > ../drivers/gpu/drm/i915/i915_drv.c:547:36: note: each undeclared identifier is reported only once for each function it appears in
> > > > > >   CC      net/dccp/qpolicy.o
> > > > > > cc1: some warnings being treated as errors
> > > > > > make[5]: *** [drivers/gpu/drm/i915/i915_drv.o] Error 1
> > > > > 
> > > > > Thanks for the report, we'll fix it.
> > > > > 
> > > > > Can anyone explain why include/linux/acpi_bus.h has #ifdef
> > > > > CONFIG_ACPI_SLEEP and conditional build for a dummy inline version of
> > > > > acpi_target_system_state(), *but* that does not get included or used if
> > > > > CONFIG_ACPI=n? Additionally, the combination of CONFIG_ACPI=y and
> > > > > CONFIG_ACPI_SLEEP=n does not seem to work at all.
> > > > 
> > > > These two things look like bugs to me.  Most likely not tested thoruoughly
> > > > enough.
> > > > 
> > > > > So we'll really have to sprinkle #ifdef CONFIG_ACPI all over, instead of
> > > > > neatly using the dummy versions that someone has gone through the
> > > > > trouble of adding?
> > > > 
> > > > No, we don't have to.
> > > 
> > > Back from my vacation and I didn't see a conclusion to this issue here.
> > > Rafael, have you fixed this in your acpi tree or do I need to do something
> > > in drm-intel?
> > 
> > I was on vacation too. :-)
> > 
> > Please have a look if i915 includes acpi/acpi_bus.h directly anywhere.  If so,
> > it should include linux/acpi.h instead.  I'll fix up the rest in the ACPI tree.
> 
> We seem to only use linux/acpi.h and acpi/(video|button).h, at least
> according to a grep include.*acpi. So I think we're good in i915 land.
> Thanks for taking care of this.

The patch below should fix this if I'm not mistaken.

Rafael

---
From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Subject: ACPI / sleep: Fix up acpi_target_system_state() stub definition

The static inline stub for acpi_target_system_state() is defined in
include/acpi/acpi_bus.h, but that file is only included if CONFIG_ACPI
is set, so drivers that use acpi_target_system_state() will fail to
build for CONFIG_ACPI unset.

To prevent that from happening move the definition of the static
inline stub for acpi_target_system_state() to include/linux/acpi.h.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 include/acpi/acpi_bus.h |    6 ------
 include/linux/acpi.h    |    6 ++++++
 2 files changed, 6 insertions(+), 6 deletions(-)

Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -566,12 +566,6 @@ static inline int acpi_pm_device_sleep_w
 }
 #endif
 
-#ifdef CONFIG_ACPI_SLEEP
-u32 acpi_target_system_state(void);
-#else
-static inline u32 acpi_target_system_state(void) { return ACPI_STATE_S0; }
-#endif
-
 static inline bool acpi_device_power_manageable(struct acpi_device *adev)
 {
 	return adev->flags.power_manageable;
Index: linux-pm/include/linux/acpi.h
===================================================================
--- linux-pm.orig/include/linux/acpi.h
+++ linux-pm/include/linux/acpi.h
@@ -541,6 +541,12 @@ static inline void arch_reserve_mem_area
 #define acpi_os_set_prepare_sleep(func, pm1a_ctrl, pm1b_ctrl) do { } while (0)
 #endif
 
+#ifdef CONFIG_ACPI_SLEEP
+u32 acpi_target_system_state(void);
+#else
+static inline u32 acpi_target_system_state(void) { return ACPI_STATE_S0; }
+#endif
+
 #if defined(CONFIG_ACPI) && defined(CONFIG_PM_RUNTIME)
 int acpi_dev_runtime_suspend(struct device *dev);
 int acpi_dev_runtime_resume(struct device *dev);

