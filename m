Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933Ab3HEJ02 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 05:26:28 -0400
Received: from r-mail2.rd.orange.com ([217.108.152.42]:22055 "EHLO
	r-mail2.rd.orange.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151Ab3HEJ00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 05:26:26 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Michal Marek <mmarek@suse.cz>
Subject: Re: Warnings from silentoldconfig (Re: [GIT PULL] PCI updates for v3.11)
Date: Mon, 5 Aug 2013 11:26:21 +0200
User-Agent: KMail/1.13.5 (Linux/3.9.11-ilmarinen-nv; KDE/4.4.5; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kbuild" <linux-kbuild@vger.kernel.org>
References: <20130802181740.GA27100@google.com> <CA+55aFzSG8ny=79_MFik5xP99c7eb-LMKh0JzTKpbiEB8Wt=5Q@mail.gmail.com> <20130805083943.GA14782@sepie.suse.cz>
In-Reply-To: <20130805083943.GA14782@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201308051126.21882.yann.morin.1998@free.fr>
X-OriginalArrivalTime: 05 Aug 2013 09:26:22.0353 (UTC) FILETIME=[D9759010:01CE91BD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal, All,

On Monday 05 August 2013 10:39:43 Michal Marek wrote:
> On Fri, Aug 02, 2013 at 01:28:25PM -0700, Linus Torvalds wrote:
> > On Fri, Aug 2, 2013 at 11:17 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> > >
> > > Yinghai is still working on another SR-IOV-related fix or two, which
> > > will be simpler if pciehp is non-modular, so I included the Kconfig
> > > changes now to get them in earlier.
> > 
> > Hmm. Doing a trivial "make allmoconfig" for testing, I get
> > 
> >   include/config/auto.conf:3014:warning: symbol value 'm' invalid for
> > HOTPLUG_PCI_PCIE
> >   include/config/auto.conf:4711:warning: symbol value 'm' invalid for
> > HOTPLUG_PCI
> > 
> > but that may be a build system issue with stale data from the
> > *previous* "make allmodconfig". Regardless, that makes me worried.
> > 
> > Adding Michal Marek to the discussion. I'm currently doing a new "make
> > allmodconfig" after having done a "git clean -dqfx" to see if the
> > error remains. If it does, I will unpull. If it is gone, I'm going to
> > assume the Kconfig changes are ok, but that our build system is
> > missing some dependency.
> 
> Added Yann and the linux-kbuild list to CC. Reproducer:
> 
>   git checkout 1fe0135
>   make mrproper
>   make allmodconfig
>   make silentoldconfig
>   git checkout aa8032b
>   make allmodconfig
>   make silentoldconfig
> 
> conf_write_autoconf() first calls conf_split_config() to generate the
> include/config/**.h hierarchy, then generates include/config/auto.conf.
> For some reason, conf_split_config() reads include/config/auto.conf,
> which may not exist yet or may be out of date. Yann, can anything break
> if we simply do not read that file from conf_split_config(), like this?

Sorry, that's a part I'm not sure about, and seems non-trivial.
I'll look at it tonight (UTC+2) when I'm back home.

Regards,
Yann E. MORIN.

> diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
> index c55c227..8c90835 100644
> --- a/scripts/kconfig/confdata.c
> +++ b/scripts/kconfig/confdata.c
> @@ -829,16 +829,12 @@ next:
>  
>  static int conf_split_config(void)
>  {
> -	const char *name;
>  	char path[PATH_MAX+1];
>  	char *s, *d, c;
>  	struct symbol *sym;
>  	struct stat sb;
>  	int res, i, fd;
>  
> -	name = conf_get_autoconfig_name();
> -	conf_read_simple(name, S_DEF_AUTO);
> -
>  	if (chdir("include/config"))
>  		return 1;
>  
> Thanks,
> Michal
> 

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +0/33 662376056 | Software  Designer | \ / CAMPAIGN     |   ^                |
| --==< O_o >==-- '------------.-------:  X  AGAINST      |  /e\  There is no  |
| http://ymorin.is-a-geek.org/ | (*_*) | / \ HTML MAIL    |  """  conspiracy.  |
'------------------------------'-------'------------------'--------------------'
