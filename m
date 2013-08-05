Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851Ab3HEW6k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 18:58:40 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:46158 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755762Ab3HEW6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 18:58:38 -0400
Date: Tue, 6 Aug 2013 00:58:30 +0200
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Michal Marek <mmarek@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: Warnings from silentoldconfig (Re: [GIT PULL] PCI updates for
 v3.11)
Message-ID: <20130805225830.GA29411@free.fr>
References: <20130802181740.GA27100@google.com>
 <CA+55aFzSG8ny=79_MFik5xP99c7eb-LMKh0JzTKpbiEB8Wt=5Q@mail.gmail.com>
 <20130805083943.GA14782@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130805083943.GA14782@sepie.suse.cz>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal, All,

On 2013-08-05 10:39 +0200, Michal Marek spake thusly:
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
> 
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

So, first off, this is not something I am comfortable with. So I've done
some (quick) research on this, and did some testing (see below).

So, looking at .config after 'make allmodconfig', the HOTPLUG_PCI and
HOTPLUG_PCI_PCIE symbols are indeed set to 'y' in .config, which is
expected and correct. include/config/auto.conf still has them set to
'm', which is not wrong since it has not been re-generated.

Finally, after make silentoldconfig, they are both set to 'y' both in
.config and in include/config/auto.conf. Expected and correct.

This means the warning just informs us that a symbol's type has changed
to a more restricted type (eg. tristate -> bool), and is not really a
problem, since both .config and auto.conf are correct afterward.

Then, as Michal explained, the warning happens while we are in
conf_write_autoconf(), which is called after we have dealt with all
symbols, and they are expected to be properly set now. But then, we
read include/config/auto.conf, and I get a bit lost there.

What I understand of the code is that, we're reading auto.conf with
the S_DEF_AUTO flag, which is expected to set the SYMBOL_DEF_AUTO flags
to symbols read from auto.conf.

This is then used by conf_split_config to detect symbols that have
changed.

Basically, it loops over all symbols as such:

    for_all_symbols(...) {
        if (!has_changed(symbol))
            continue
        touch include/config/symbol.h
    }

has_changed(symbol) checks the old value is the same (or isn't) as the
new value. Is it's the same, nothing happens. Otherwise, as the value
has changed, the empty symbol.h file is generated to trigger dependency
tracking in the build-system.

So I checked if the .h files in include/config/ were touched.

The two following tests do not invlolve the HOTPLUG_PCI_.* symbols
on purpose, and involve a pristine master c095ba7:

    $ make allmodconfig
    $ make silentoldconfig
    $ make silentoldconfig
    $ make silentoldconfig

  - Without Michal's proposed change, unaffected symbols are not
    touched. For example, mtime and ctime for zswap.h are not changed
    after the second and third silentoldconfig.

  - With Michal's proposed change, then mtime and ctime for zswap.h are
    changed after each silentoldconfig, even though CONFIG_ZSWAP was not
    changed.

So, I'm afraid this change is incorrect, since it would mean dependency
tracking would detect targets not to be up-to-date, and everything would
be rebuilt.

Also, the issue has pre-existed for a long time and is only detected
now. I think the tristate->bool conversions in this thread just exposed
the issue, and are not the root cause.

One solution would be to read auto.conf *before* we fuzz around symbols,
not after. We should probably read auto.conf just after we read .config.

I've spent my whole evening on this issue, it's past 00:45 here, and I'm
slowly drifting away now... ;-)

I believe the warning to be just spurious, so it can bear one more day
before I can tackle this again.

In any case, I've found the kconfig code to be relatively difficult to
read and follow... :-( It's mostly an agglomerate of orgnic changes
accumulated over time, it is missing coments in the right places, is
rather complex with a lot of special cases spread out all over, and I
fell like wanting to knit after a slew of kitten has played with tens of
balls of wool... :-(

Anyway, with time, I'm eventually sorting things out one at a time, but
Woo... the headache... ;-]

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
