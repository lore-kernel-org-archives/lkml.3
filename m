Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093Ab3HEIjt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 04:39:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43344 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754541Ab3HEIjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 04:39:47 -0400
Date: Mon, 5 Aug 2013 10:39:43 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Warnings from silentoldconfig (Re: [GIT PULL] PCI updates for v3.11)
Message-ID: <20130805083943.GA14782@sepie.suse.cz>
References: <20130802181740.GA27100@google.com>
 <CA+55aFzSG8ny=79_MFik5xP99c7eb-LMKh0JzTKpbiEB8Wt=5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzSG8ny=79_MFik5xP99c7eb-LMKh0JzTKpbiEB8Wt=5Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 02, 2013 at 01:28:25PM -0700, Linus Torvalds wrote:
> On Fri, Aug 2, 2013 at 11:17 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> >
> > Yinghai is still working on another SR-IOV-related fix or two, which
> > will be simpler if pciehp is non-modular, so I included the Kconfig
> > changes now to get them in earlier.
> 
> Hmm. Doing a trivial "make allmoconfig" for testing, I get
> 
>   include/config/auto.conf:3014:warning: symbol value 'm' invalid for
> HOTPLUG_PCI_PCIE
>   include/config/auto.conf:4711:warning: symbol value 'm' invalid for
> HOTPLUG_PCI
> 
> but that may be a build system issue with stale data from the
> *previous* "make allmodconfig". Regardless, that makes me worried.
> 
> Adding Michal Marek to the discussion. I'm currently doing a new "make
> allmodconfig" after having done a "git clean -dqfx" to see if the
> error remains. If it does, I will unpull. If it is gone, I'm going to
> assume the Kconfig changes are ok, but that our build system is
> missing some dependency.

Added Yann and the linux-kbuild list to CC. Reproducer:

  git checkout 1fe0135
  make mrproper
  make allmodconfig
  make silentoldconfig
  git checkout aa8032b
  make allmodconfig
  make silentoldconfig

conf_write_autoconf() first calls conf_split_config() to generate the
include/config/**.h hierarchy, then generates include/config/auto.conf.
For some reason, conf_split_config() reads include/config/auto.conf,
which may not exist yet or may be out of date. Yann, can anything break
if we simply do not read that file from conf_split_config(), like this?

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index c55c227..8c90835 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -829,16 +829,12 @@ next:
 
 static int conf_split_config(void)
 {
-	const char *name;
 	char path[PATH_MAX+1];
 	char *s, *d, c;
 	struct symbol *sym;
 	struct stat sb;
 	int res, i, fd;
 
-	name = conf_get_autoconfig_name();
-	conf_read_simple(name, S_DEF_AUTO);
-
 	if (chdir("include/config"))
 		return 1;
 
Thanks,
Michal
