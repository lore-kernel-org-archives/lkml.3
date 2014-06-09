Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551AbaFIRik (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 13:38:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41228 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754716AbaFIRij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 13:38:39 -0400
Date: Mon, 9 Jun 2014 19:38:36 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: David Rientjes <rientjes@google.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Pekka Enberg <penberg@kernel.org>, Michal Marek <mmarek@suse.cz>,
        Randy Dunlap <rdunlap@infradead.org>, levinsasha928@gmail.com,
        mtosatti@redhat.com, fengguang.wu@intel.com,
        David Vrabel <david.vrabel@citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        xen-devel@lists.xenproject.org
Subject: Re: [PATCH 2/3] x86, platform, xen, kconfig: add xen defconfig
	helper
Message-ID: <20140609173836.GN22052@wotan.suse.de>
References: <1402096269-4512-1-git-send-email-mcgrof@do-not-panic.com> <1402096269-4512-2-git-send-email-mcgrof@do-not-panic.com> <alpine.DEB.2.02.1406070208540.12573@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1406070208540.12573@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 07, 2014 at 02:11:32AM -0700, David Rientjes wrote:
> On Fri, 6 Jun 2014, Luis R. Rodriguez wrote:
> 
> > diff --git a/arch/x86/Makefile b/arch/x86/Makefile
> > index 37621ac..9db34e2 100644
> > --- a/arch/x86/Makefile
> > +++ b/arch/x86/Makefile
> > @@ -256,6 +256,12 @@ kvmconfig:
> >  	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/kconfig/merge_config.sh -m -O $(objtree) $(objtree)/.config $(srctree)/arch/x86/configs/kvm_guest.config
> >  	$(Q)yes "" | $(MAKE) -f $(srctree)/Makefile oldconfig
> >  
> > +PHONY += xenconfig
> > +xenconfig:
> > +	$(if $(wildcard $(objtree)/.config),, $(error You need an existing .config for this target))
> > +	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/kconfig/merge_config.sh -m -O $(objtree) $(objtree)/.config $(srctree)/arch/x86/configs/xen.config
> > +	$(Q)yes "" | $(MAKE) -f $(srctree)/Makefile oldconfig
> > +
> >  define archhelp
> >    echo  '* bzImage      - Compressed kernel image (arch/x86/boot/bzImage)'
> >    echo  '  install      - Install kernel using'
> > @@ -270,4 +276,5 @@ define archhelp
> >    echo  '                  FDARGS="..."  arguments for the booted kernel'
> >    echo  '                  FDINITRD=file initrd for the booted kernel'
> >    echo  '  kvmconfig	- Enable additional options for kvm guest kernel support'
> > +  echo  '  xenconfig    - Enable additional options for xen dom0 and guest kernel support'
> >  endef
> 
> I suppose it would be easier to generalize the functionality and do 
> something like this instead since the two are otherwise identical:
> 
> diff --git a/arch/x86/Makefile b/arch/x86/Makefile
> --- a/arch/x86/Makefile
> +++ b/arch/x86/Makefile
> @@ -250,11 +250,19 @@ archclean:
>  	$(Q)$(MAKE) $(clean)=$(boot)
>  	$(Q)$(MAKE) $(clean)=arch/x86/tools
>  
> +define build-virtconfig
> +$(if $(wildcard $(objtree)/.config),, $(error You need an existing .config for this target))
> +$(Q)$(CONFIG_SHELL) $(srctree)/scripts/kconfig/merge_config.sh -m -O $(objtree) $(objtree)/.config $(srctree)/arch/x86/configs/$(1)
> +$(Q)yes "" | $(MAKE) -f $(srctree)/Makefile oldconfig
> +endef
> +
>  PHONY += kvmconfig
>  kvmconfig:
> -	$(if $(wildcard $(objtree)/.config),, $(error You need an existing .config for this target))
> -	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/kconfig/merge_config.sh -m -O $(objtree) $(objtree)/.config $(srctree)/arch/x86/configs/kvm_guest.config
> -	$(Q)yes "" | $(MAKE) -f $(srctree)/Makefile oldconfig
> +	$(call build-virtconfig,kvm_guest.config)
> +
> +PHONY += xenconfig
> +xenconfig:
> +	$(call build-virtconfig,xen.config)
>  
>  define archhelp
>    echo  '* bzImage      - Compressed kernel image (arch/x86/boot/bzImage)'
> 

Good idea, I've folded this as a first patch then and will resubmit, dropping
the virtconfig kconfig option.

  Luis
