Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422814AbaKNW1d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 17:27:33 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:60846 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1161920AbaKNW1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 17:27:31 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: paulmck@linux.vnet.ibm.com
Cc: Konstantin Khlebnikov <koct9i@gmail.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
        Tom Boshoven <tomboshoven@gmail.com>, x86@kernel.org,
        Josh Triplett <josh@joshtriplett.org>,
        Alexander Monakov <amonakov@gmail.com>
Subject: Re: [PATCH v2] ACPI/osl: speedup grace period in acpi_os_map_cleanup
Date: Fri, 14 Nov 2014 23:48:30 +0100
Message-ID: <18413590.CmnVIhvXn9@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141109220038.GH4901@linux.vnet.ibm.com>
References: <20141108094717.9388.34638.stgit@zurg> <20141109105337.4952.36899.stgit@zurg> <20141109220038.GH4901@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, November 09, 2014 02:00:38 PM Paul E. McKenney wrote:
> On Sun, Nov 09, 2014 at 01:53:37PM +0400, Konstantin Khlebnikov wrote:
> > ACPI maintains cache of ioremap regions to speed up operations and
> > access to them from irq context where ioremap() calls aren't allowed.
> > This code abuses synchronize_rcu() on unmap path for synchronization
> > with fast-path in acpi_os_read/write_memory which uses this cache.
> > 
> > Since v3.10 CPUs are allowed to enter idle state even if they have RCU
> > callbacks queued, see commit c0f4dfd4f90f1667d234d21f15153ea09a2eaa66
> > ("rcu: Make RCU_FAST_NO_HZ take advantage of numbered callbacks").
> > That change caused problems with nvidia proprietary driver which calls
> > acpi_os_map/unmap_generic_address several times during initialization.
> > Each unmap calls synchronize_rcu and adds significant delay. Totally
> > initialization is slowed for a couple of seconds and that is enough to
> > trigger timeout in hardware, gpu decides to "fell off the bus". Widely
> > spread workaround is reducing "rcu_idle_gp_delay" from 4 to 1 jiffy.
> > 
> > This patch replaces synchronize_rcu() with synchronize_rcu_expedited()
> > which is much faster.
> > 
> > Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
> > Reported-and-tested-by: Alexander Monakov <amonakov@gmail.com>
> > Cc: Tom Boshoven <tomboshoven@gmail.com>
> > Link: https://devtalk.nvidia.com/default/topic/567297/linux/linux-3-10-driver-crash/
> 
> Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Patch queued up for 3.19, thanks!

> 
> > ---
> >  drivers/acpi/osl.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> > index 9964f70..217713c 100644
> > --- a/drivers/acpi/osl.c
> > +++ b/drivers/acpi/osl.c
> > @@ -436,7 +436,7 @@ static void acpi_os_drop_map_ref(struct acpi_ioremap *map)
> >  static void acpi_os_map_cleanup(struct acpi_ioremap *map)
> >  {
> >  	if (!map->refcount) {
> > -		synchronize_rcu();
> > +		synchronize_rcu_expedited();
> >  		acpi_unmap(map->phys, map->virt);
> >  		kfree(map);
> >  	}
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
