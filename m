Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873AbaCYVTb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 17:19:31 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:9458 "EHLO
	mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751335AbaCYVT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 17:19:29 -0400
X-IronPort-AV: E=Sophos;i="4.97,730,1389740400"; 
   d="scan'208";a="54105231"
Date: Tue, 25 Mar 2014 22:19:21 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Thomas Gleixner <tglx@linutronix.de>
cc: Julia Lawall <julia.lawall@lip6.fr>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 00/16] timers: Plug debugobject leaks and use del_timer_sync()
 in exit/teardown
In-Reply-To: <alpine.DEB.2.02.1403252146070.4094@ionos.tec.linutronix.de>
Message-ID: <alpine.DEB.2.02.1403252219020.2030@localhost6.localdomain6>
References: <20140323150557.288925975@linutronix.de> <alpine.DEB.2.02.1403232328480.2019@localhost6.localdomain6> <alpine.DEB.2.02.1403252146070.4094@ionos.tec.linutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks.  I haven't had time to send them out, but I could do so tomorrow 
afternoon.

julia

On Tue, 25 Mar 2014, Thomas Gleixner wrote:

> On Sun, 23 Mar 2014, Julia Lawall wrote:
> > diff -u -p a/arch/mips/lasat/picvue_proc.c b/arch/mips/lasat/picvue_proc.c
> > --- a/arch/mips/lasat/picvue_proc.c
> > +++ b/arch/mips/lasat/picvue_proc.c
> > @@ -175,7 +175,7 @@ static void pvc_proc_cleanup(void)
> >  	remove_proc_entry("scroll", pvc_display_dir);
> >  	remove_proc_entry(DISPLAY_DIR_NAME, NULL);
> >  
> > -	del_timer(&timer);
> > +	del_timer_sync(&timer);
> 
> Correct.
> 
> >  }
> >  
> >  static int __init pvc_proc_init(void)
> > diff -u -p a/drivers/tty/serial/mux.c b/drivers/tty/serial/mux.c
> > --- a/drivers/tty/serial/mux.c
> > +++ b/drivers/tty/serial/mux.c
> > @@ -613,7 +613,7 @@ static void __exit mux_exit(void)
> >  {
> >  	/* Delete the Mux timer. */
> >  	if(port_cnt > 0) {
> > -		del_timer(&mux_timer);
> > +		del_timer_sync(&mux_timer);
> 
> Correct.
> 
> >  #ifdef CONFIG_SERIAL_MUX_CONSOLE
> >  		unregister_console(&mux_console);
> >  #endif
> > diff -u -p a/drivers/input/serio/hp_sdc.c b/drivers/input/serio/hp_sdc.c
> > --- a/drivers/input/serio/hp_sdc.c
> > +++ b/drivers/input/serio/hp_sdc.c
> > @@ -984,7 +984,7 @@ static void hp_sdc_exit(void)
> >  	free_irq(hp_sdc.irq, &hp_sdc);
> >  	write_unlock_irq(&hp_sdc.lock);
> >  
> > -	del_timer(&hp_sdc.kicker);
> > +	del_timer_sync(&hp_sdc.kicker);
> 
> Correct.
>   
> >  	tasklet_kill(&hp_sdc.task);
> >  
> > diff -u -p a/drivers/isdn/sc/init.c b/drivers/isdn/sc/init.c
> > --- a/drivers/isdn/sc/init.c
> > +++ b/drivers/isdn/sc/init.c
> > @@ -390,8 +390,8 @@ static void __exit sc_exit(void)
> >  		/*
> >  		 * kill the timers
> >  		 */
> > -		del_timer(&(sc_adapter[i]->reset_timer));
> > -		del_timer(&(sc_adapter[i]->stat_timer));
> > +		del_timer_sync(&(sc_adapter[i]->reset_timer));
> > +		del_timer_sync(&(sc_adapter[i]->stat_timer));
> 
> Correct.
>   
> >  		/*
> >  		 * Tell I4L we're toast
> > diff -u -p a/drivers/isdn/i4l/isdn_common.c b/drivers/isdn/i4l/isdn_common.c
> > --- a/drivers/isdn/i4l/isdn_common.c
> > +++ b/drivers/isdn/i4l/isdn_common.c
> > @@ -2381,7 +2381,7 @@ static void __exit isdn_exit(void)
> >  	}
> >  	isdn_tty_exit();
> >  	unregister_chrdev(ISDN_MAJOR, "isdn");
> > -	del_timer(&dev->timer);
> > +	del_timer_sync(&dev->timer);
> 
> Correct.
> 
> >  	/* call vfree with interrupts enabled, else it will hang */
> >  	vfree(dev);
> >  	printk(KERN_NOTICE "ISDN-subsystem unloaded\n");
> > diff -u -p a/drivers/isdn/hardware/mISDN/hfcpci.c b/drivers/isdn/hardware/mISDN/hfcpci.c
> > --- a/drivers/isdn/hardware/mISDN/hfcpci.c
> > +++ b/drivers/isdn/hardware/mISDN/hfcpci.c
> > @@ -2352,7 +2352,7 @@ static void __exit
> >  HFC_cleanup(void)
> >  {
> >  	if (timer_pending(&hfc_tl))
> > -		del_timer(&hfc_tl);
> > +		del_timer_sync(&hfc_tl);
> 
> That's incomplete the timer_pending() check is racy as well and the
> timer is rearming itself from the callback.
>   
> >  	pci_unregister_driver(&hfc_driver);
> >  }
> > diff -u -p a/drivers/isdn/act2000/module.c b/drivers/isdn/act2000/module.c
> > --- a/drivers/isdn/act2000/module.c
> > +++ b/drivers/isdn/act2000/module.c
> > @@ -796,7 +796,7 @@ static void __exit act2000_exit(void)
> >  	act2000_card *last;
> >  	while (card) {
> >  		unregister_card(card);
> > -		del_timer(&card->ptimer);
> > +		del_timer_sync(&card->ptimer);
> 
> Correct.
> 
> >  		card = card->next;
> >  	}
> >  	card = cards;
> > diff -u -p a/drivers/net/hamradio/yam.c b/drivers/net/hamradio/yam.c
> > --- a/drivers/net/hamradio/yam.c
> > +++ b/drivers/net/hamradio/yam.c
> > @@ -1184,7 +1184,7 @@ static void __exit yam_cleanup_driver(vo
> >  	struct yam_mcs *p;
> >  	int i;
> >  
> > -	del_timer(&yam_timer);
> > +	del_timer_sync(&yam_timer);
> 
> Correct.
> 
> >  	for (i = 0; i < NR_PORTS; i++) {
> >  		struct net_device *dev = yam_devs[i];
> >  		if (dev) {
> > diff -u -p a/drivers/staging/speakup/main.c b/drivers/staging/speakup/main.c
> > --- a/drivers/staging/speakup/main.c
> > +++ b/drivers/staging/speakup/main.c
> > @@ -2218,7 +2218,7 @@ static void __exit speakup_exit(void)
> >  	unregister_keyboard_notifier(&keyboard_notifier_block);
> >  	unregister_vt_notifier(&vt_notifier_block);
> >  	speakup_unregister_devsynth();
> > -	del_timer(&cursor_timer);
> > +	del_timer_sync(&cursor_timer);
> 
> Not sure about that one as the timer might be rearmed, so the
> invocation might need to be further down the cleanup path.
> 
> >  	kthread_stop(speakup_task);
> >  	speakup_task = NULL;
> >  	mutex_lock(&spk_mutex);
> > diff -u -p a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
> > --- a/drivers/staging/panel/panel.c
> > +++ b/drivers/staging/panel/panel.c
> > @@ -2298,7 +2298,7 @@ static void __exit panel_cleanup_module(
> >  	unregister_reboot_notifier(&panel_notifier);
> >  
> >  	if (scan_timer.function != NULL)
> > -		del_timer(&scan_timer);
> > +		del_timer_sync(&scan_timer);
> 
> Correct.
> 
> >  	if (pprt != NULL) {
> >  		if (keypad_enabled) {
> > diff -u -p a/drivers/staging/lustre/lustre/llite/super25.c b/drivers/staging/lustre/lustre/llite/super25.c
> > --- a/drivers/staging/lustre/lustre/llite/super25.c
> > +++ b/drivers/staging/lustre/lustre/llite/super25.c
> > @@ -197,7 +197,7 @@ static void __exit exit_lustre_lite(void
> >  {
> >  	ll_xattr_fini();
> >  	vvp_global_fini();
> > -	del_timer(&ll_capa_timer);
> > +	del_timer_sync(&ll_capa_timer);
> 
> Looks wrong, as the timer might be rearmed by the thread which is
> not yet stopped.
> 
> >  	ll_capa_thread_stop();
> >  	LASSERTF(capa_count[CAPA_SITE_CLIENT] == 0,
> >  		 "client remaining capa count %d\n",
> > diff -u -p a/drivers/atm/idt77105.c b/drivers/atm/idt77105.c
> > --- a/drivers/atm/idt77105.c
> > +++ b/drivers/atm/idt77105.c
> > @@ -369,8 +369,8 @@ EXPORT_SYMBOL(idt77105_init);
> >  static void __exit idt77105_exit(void)
> >  {
> >          /* turn off timers */
> > -        del_timer(&stats_timer);
> > -        del_timer(&restart_timer);
> > +        del_timer_sync(&stats_timer);
> > +        del_timer_sync(&restart_timer);
> 
> Yep.
> 
> >  }
> >  
> >  module_exit(idt77105_exit);
> > diff -u -p a/drivers/atm/nicstar.c b/drivers/atm/nicstar.c
> > --- a/drivers/atm/nicstar.c
> > +++ b/drivers/atm/nicstar.c
> > @@ -306,7 +306,7 @@ static void __exit nicstar_cleanup(void)
> >  {
> >  	XPRINTK("nicstar: nicstar_cleanup() called.\n");
> >  
> > -	del_timer(&ns_timer);
> > +	del_timer_sync(&ns_timer);
> >  
> 
> The driver might still be in use, as the devices are shut down via the
> pci_unregister_driver() call below. So while it's correct to use
> del_timer_sync() it's not clear w/o digging deeper into the code
> whether it's actually sufficient.
> 
> >  	pci_unregister_driver(&nicstar_driver);
> >  
> > diff -u -p a/drivers/atm/iphase.c b/drivers/atm/iphase.c
> > --- a/drivers/atm/iphase.c
> > +++ b/drivers/atm/iphase.c
> > @@ -3289,7 +3289,7 @@ static void __exit ia_module_exit(void)
> >  {
> >  	pci_unregister_driver(&ia_driver);
> >  
> > -        del_timer(&ia_timer);
> > +        del_timer_sync(&ia_timer);
> 
> The timer is self rearming and has protection against the removal of
> the devices. So it should be fine.
> 
> >  }
> >  
> >  module_init(ia_module_init);
> > diff -u -p a/net/hsr/hsr_main.c b/net/hsr/hsr_main.c
> > --- a/net/hsr/hsr_main.c
> > +++ b/net/hsr/hsr_main.c
> > @@ -459,7 +459,7 @@ static int __init hsr_init(void)
> >  static void __exit hsr_exit(void)
> >  {
> >  	unregister_netdevice_notifier(&hsr_nb);
> > -	del_timer(&prune_timer);
> > +	del_timer_sync(&prune_timer);
> 
> Correct as the only rearm is from the timer callback itself
> 
> >  	hsr_netlink_exit();
> >  	dev_remove_pack(&hsr_pt);
> >  }
> > diff -u -p a/net/atm/mpc.c b/net/atm/mpc.c
> > --- a/net/atm/mpc.c
> > +++ b/net/atm/mpc.c
> > @@ -1492,7 +1492,7 @@ static void __exit atm_mpoa_cleanup(void
> >  
> >  	mpc_proc_clean();
> >  
> > -	del_timer(&mpc_timer);
> > +	del_timer_sync(&mpc_timer);
> 
> Looks correct as well. Timer is rearming no other dependencies.
> 
> >  	unregister_netdevice_notifier(&mpoa_notifier);
> >  	deregister_atm_ioctl(&atm_ioctl_ops);
> 
> Thanks,
> 
> 	tglx
> 
> 
