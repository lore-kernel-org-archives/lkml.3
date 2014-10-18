Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358AbaJRJfn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 05:35:43 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:55231 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbaJRJfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 05:35:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>, devicetree@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Darren Hart <dvhart@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v5 09/12] Driver core: Unified interface for firmware node properties
Date: Sat, 18 Oct 2014 11:35:21 +0200
Message-ID: <1979177.qygBOVQh8h@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1628104.Ek1EGbdVha@vostro.rjw.lan>
References: <2660541.BycO7TFnA2@vostro.rjw.lan> <11223831.j9KAEfSQsY@vostro.rjw.lan> <1628104.Ek1EGbdVha@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:vsG4t3g4h5XJM6A5RpiAdVEu5MnG/SAWpHRDbExHJmr
 nqwMHtjgkenR5Cxvp6is75zRsvjSPmBROST/gSI5pzWmkqIeTR
 TMtkKj43QyhUdJwNsIRnG2KFTn5b0sbQ7wE/Dke9XoAB4FtgNx
 QbfEU0S+ABnhIcUTUVL7zG4lgHBwyAzM735/l2MmHn4Wu4eTxQ
 7o9gFGFc8JYFE5eX6AetJm8J9uProBhKxNxPFdusgNxziNnnbc
 2CNvWAecBE7OKZBB4m+6laJHsKG/YG2L3BfBUFo//8NgPYALe3
 PBOEY6w0rNUwK3Gc4OHdgod4NR+ExmWdzr634zFlsol/aIjK9u
 ueXVg7glEr3zUjWDNJyA=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 October 2014 14:14:53 Rafael J. Wysocki wrote:
> +/**
> + * fwnode_property_present - check if a property of a firmware node is present
> + * @fwnode: Firmware node whose property to check
> + * @propname: Name of the property
> + */
> +bool fwnode_property_present(struct fwnode_handle *fwnode, const char *propname)
> +{
> +       if (is_of_node(fwnode))
> +               return of_property_read_bool(of_node(fwnode), propname);
> +       else if (is_acpi_node(fwnode))
> +               return !acpi_dev_prop_get(acpi_node(fwnode), propname, NULL);
> +
> +       return false;
> +}
> +EXPORT_SYMBOL_GPL(fwnode_property_present);
> 

Should this be

		return acpi_dev_prop_get(acpi_node(fwnode), propname, NULL);

without the '!'?

I'm also unsure about the '_present' vs '_read_bool' naming. IIRC we had
a long debate about this before we decided on 'read_bool' for DT, and
I don't really want to start a new debate, but being consistent would
be nice.

We could of course have

static inline bool fwnode_property_read_bool(struct fwnode_handle *fwnode, const char *propname)
{
	return fwnode_property_present(fwnode, propname);
}

which is completely redundant, but would help for drivers using the
interface to document whether we are checking for bool property that
we expect to be either empty or absent (_get_bool), vs checking for
the presence of a non-empty property (_present).

	Arnd
