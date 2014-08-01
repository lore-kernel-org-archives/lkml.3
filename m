Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143AbaHARVi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 13:21:38 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:35985 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752571AbaHARVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 13:21:15 -0400
Message-ID: <1406913669.22529.44.camel@hornet>
Subject: Re: [PATCH 5/5] platform: Make platform_bus device a platform device
From: Pawel Moll <pawel.moll@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@wwwdotorg.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "paul@pwsan.com" <paul@pwsan.com>, Arnd Bergmann <arnd@arndb.de>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "arm@kernel.org" <arm@kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 01 Aug 2014 18:21:09 +0100
In-Reply-To: <20140726201351.GC21870@kroah.com>
References: <1406298233-27876-1-git-send-email-pawel.moll@arm.com>
	 <1406298233-27876-5-git-send-email-pawel.moll@arm.com>
	 <20140726201351.GC21870@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-07-26 at 21:13 +0100, Greg Kroah-Hartman wrote:
> > @@ -946,12 +946,20 @@ int __init platform_bus_init(void)
> >  
> >  	early_platform_cleanup();
> >  
> > -	error = device_register(&platform_bus);
> > +	dev_set_name(&platform_bus.dev, "%s", platform_bus.name);
> > +	error = device_register(&platform_bus.dev);
> >  	if (error)
> >  		return error;
> >  	error =  bus_register(&platform_bus_type);
> > -	if (error)
> > -		device_unregister(&platform_bus);
> > +	if (!error) {
> > +#ifdef CONFIG_OF
> > +		platform_bus.dev.of_node = of_allnodes;
> > +#endif
> 
> Why are you doing this?  The original code didn't do it and all was
> fine, right?  What changes here?

You mean the #ifdef? It wasn't there, but Olof figured out that it
breaks !CONFIG_OF builds:

http://article.gmane.org/gmane.linux.ports.tegra/18473

as of_allnodes is only defined when CONFIG_OF. I had a choice of
#ifdefing the assignment above or providing a dummy symbol. The latter
doesn't seem sensibly, as there should be no other users for it (the
symbol).

Pawel

