Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365AbaBQSXR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 13:23:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46693 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752436AbaBQSXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 13:23:16 -0500
From: Thomas Renninger <trenn@suse.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Conrad Kostecki <ck@conrad-kostecki.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, devel@acpica.org
Subject: Re: AW: AW: [PATCH] x86: HPET force enable for Soekris net6501
Date: Mon, 17 Feb 2014 19:23:10 +0100
Message-ID: <1678556.oPQNyVF84j@skinner>
User-Agent: KMail/4.11.4 (Linux/3.11.6-4-desktop; KDE/4.11.4; x86_64; ; )
In-Reply-To: <09d1230f-a261-4858-a390-72df138aaa34@email.android.com>
References: <4729ad4b8d3342c1b0e29fefe4b04d6a@DB4PR04MB265.eurprd04.prod.outlook.com> <3121313.GKMnFpiL5h@skinner> <09d1230f-a261-4858-a390-72df138aaa34@email.android.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 17, 2014 09:19:03 AM H. Peter Anvin wrote:
> What I gather is that they want to add tables where there are none, and that
> the ACPI code doesn't play along because there is no RSDP nor any
> RSDT/XSDT.
Yep, this does currently not work.

Easiest I can think of instead of trying to modify RSDP or similar, is
to still pass the tables via unzipped, glued cpio which the kernel
can access early. The same way it is done for current ACPI table overriding
and early microcode passing.

Also find them via:
file = find_cpio_data(cpio_path, data, size, &offset);
(compare with drivers/acpi/osl.c)

and add them to (compare with drivers/acpi/acpica/acglobal.h):
/*
 * acpi_gbl_root_table_list is the master list of ACPI tables that were
 * found in the RSDT/XSDT.
 */
ACPI_EXTERN struct acpi_table_list acpi_gbl_root_table_list;

But right now, this is acpica internal only.
Most elegant way should be that ACPICA people would add another OS
callback:

acpi_status
acpi_os_physical_table_add(acpi_physical_address *address,
                                u32 *table_length));

which is called right after acpi_os_physical_table_override.

Implementation of it should be in osl.c again where it can easily
be tracked whether a table has been replaced already and need not to
be added, for example something like:
__initdata struct cpio_data overridden_tables[ACPI_OVERRIDE_TABLES];

ACPICA part should not be hard as well. It's some time ago, but it
may be a simple call to:
        /* Add the table to the global root table list */

        status = acpi_tb_store_table(table_desc->address, table_desc->pointer,
                                     table_desc->length, table_desc->flags,
                                     table_index);

if acpi_os_physical_table_add() has returned a valid address/length.
This would then add the table to acpica internal:

/*
 * acpi_gbl_root_table_list is the master list of ACPI tables that were
 * found in the RSDT/XSDT.
 */
ACPI_EXTERN struct acpi_table_list acpi_gbl_root_table_list;

and later all the tables in there get loaded and set up as if they
were passed from BIOS.

       Thomas


> On February 17, 2014 8:28:05 AM PST, Thomas Renninger <trenn@suse.de> wrote:
> >On Friday, February 14, 2014 10:16:41 PM Thomas Gleixner wrote:
> >> On Fri, 14 Feb 2014, H. Peter Anvin wrote:
> >> > On 02/14/2014 11:59 AM, Thomas Gleixner wrote:
> >> > > On Fri, 14 Feb 2014, H. Peter Anvin wrote:
> >> > >> On 02/14/2014 11:15 AM, Thomas Gleixner wrote:
> >> > >>> I'm fine with ACPI tables if we can provide simple means for
> >
> >embedded
> >
> >> > >>> users to load one via grub or just attach it to the kernel
> >
> >image.
> >
> >> > >> That already exists, see
> >
> >Documentation/acpi/initrd_table_override.txt.
> >
> >> > > That requires, that you have already ACPI tables.
> >> > > 
> >> > > ACPI_SIG_RSDP cannot be overridden and that's the base table you
> >
> >need
> >
> >> > > to get ACPI going in the first place. So we need support for that
> >
> >and
> >
> >> > > probably for storing the tables at some non canonical place.
> >> > 
> >> > Well, the RSDP and RSDT/XSDT are nothing but pointers to other
> >
> >tables,
> >
> >> > so if explicitly overridden I'm not sure if one actually would need
> >> > them.  That doesn't mean our current code will work without them,
> >
> >though.
> >
> >> I tried once to overload all of the tables, but failed miserably in
> >> the ACPI dungeon. RSDP was the major pain point IIRC.
> >
> >What exactly do you try to achieve?
> >I cannot imagine a use-case where RSDP  and XSDT overriding would help
> >you.
> >
> >Have you tried the current mechanism to override tables?
> >What is missing and for what do you need it for?
> >
> >I need more context, maybe I can help then.
> >
> >   Thomas

