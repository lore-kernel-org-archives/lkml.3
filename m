Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbaKCSBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 13:01:20 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:33856 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223AbaKCSBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 13:01:14 -0500
Date: Mon, 3 Nov 2014 11:59:35 -0600
From: Felipe Balbi <balbi@ti.com>
To: Guenter Roeck <linux@roeck-us.net>
CC: <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Alexander Graf <agraf@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Heiko Stuebner <heiko@sntech.de>, Lee Jones <lee.jones@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Romain Perier <romain.perier@gmail.com>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH v3 00/47] kernel: Add support for power-off handler call
 chain
Message-ID: <20141103175935.GS27425@saruman>
Reply-To: <balbi@ti.com>
References: <1414425354-10359-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9wW3yB/H9ZmnRBtb"
Content-Disposition: inline
In-Reply-To: <1414425354-10359-1-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--9wW3yB/H9ZmnRBtb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Oct 27, 2014 at 08:55:07AM -0700, Guenter Roeck wrote:
> Various drivers implement architecture and/or device specific means to
> remove power from the system.  For the most part, those drivers set the
> global variable pm_power_off to point to a function within the driver.
>=20
> This mechanism has a number of drawbacks.  Typically only one means
> to remove power is supported (at least if pm_power_off is used).
> At least in theory there can be multiple means to remove power, some of
> which may be less desirable.  For example, one mechanism might power off =
the
> entire system through an I/O port or gpio pin, while another might power =
off
> a board by disabling its power controller. Other mechanisms may really ju=
st
> execute a restart sequence or drop into the ROM monitor, or put the CPU i=
nto
> sleep mode.  Using pm_power_off can also be racy if the function pointer =
is
> set from a driver built as module, as the driver may be in the process of
> being unloaded when pm_power_off is called.  If there are multiple power-=
off
> handlers in the system, removing a module with such a handler may
> inadvertently reset the pointer to pm_power_off to NULL, leaving the syst=
em
> with no means to remove power.
>=20
> Introduce a system power-off handler call chain to solve the described
> problems.  This call chain is expected to be executed from the architectu=
re
> specific machine_power_off() function.  Drivers providing system power-off
> functionality are expected to register with this call chain.  By using the
> priority field in the notifier block, callers can control power-off handl=
er
> execution sequence and thus ensure that the power-off handler with the
> optimal capabilities to remove power for a given system is called first.
> A call chain instead of a single call to the highest priority handler is
> used to provide fallback: If multiple power-off handlers are installed,
> all handlers will be called until one actually succeeds to power off the
> system.
>=20
> Patch 01/47 implements the power-off handler API.
>=20
> Patches 02/47 to 04/47 are cleanup patches to prepare for the move of
> pm_power_off to a common location.
>=20
> Patches 05/47 to 07/47 remove references to pm_power_off from devicetree
> bindings descriptions.
>=20
> Patch 08/47 moves the pm_power_off variable from architecture code to
> kernel/reboot.c.=20
>=20
> Patches 09/47 to 34/47 convert various drivers to register with the kernel
> power-off handler instead of setting pm_power_off directly.
>=20
> Patches 35/47 to 46/47 do the same for architecture code.
>=20
> Patch 47/47 finally removes pm_power_off.
>=20
> For the most part, the individual patches include explanations why specif=
ic
> priorities were chosen, at least if the selected priority is not the defa=
ult
> priority. Subsystem and architecture maintainers are encouraged to have a=
 look
> at the selected priorities and suggest improvements.
>=20
> I ran the final code through my normal build and qemu tests. Results are
> available at http://server.roeck-us.net:8010/builders in the 'poweroff-ha=
ndler'
> column. I also built all available configurations for arm, mips, powerpc,
> m68k, and sh architectures.
>=20
> The series is available in branch poweroff-handler of my repository at
> git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git.
> It is based on 3.18-rc2.
>=20
> A note on Cc: In the initial submission I had way too many Cc:, causing t=
he
> patchset to be treated as spam by many mailers and mailing list handlers,
> which of course defeated the purpose. This time around I am cutting down
> the distribution list down significantly. My apologies to anyone I may ha=
ve
> failed to copy this time around.

you touch every single architecture with this patchset, but you didn't
care about Ccing any of the arch-specific mailing lists, like lakml ?

Please resend with proper people in Cc, IIRC RMK had a few very
important comments about the idea behind this series.

> Important changes since v2:
> - Rebased series to v3.18-rc2.
> - Do not hold any locks while executing the power-off call chain.
>   This ensures that power-off handlers are executed in the state
>   selected by the machine_power_off function for a given architecture,
>   ie without changing the current semantics of power-off callbacks and
>   machine_power_off functions.
>   Power-off handler registration and de-registration is handled in atomic
>   context with interrupts disabled to ensure that those functions are not
>   interrupted by code which powers off the system.
> - Use [xxx_]power_off[_xxx] instead of [xxx_]poweroff[_xxx] for newly
>   introduced function and variable names.
> - Use power-off instead of poweroff in descriptive text and comments.
> - Replace POWEROFF_PRIORITY_xxx with POWER_OFF_PRIORITY_xxx
> - Use ACPI: instead of acpi: for messages in acpi code.
>=20
> Important changes since v1:
> - Rebased series to v3.18-rc1.
> - Use raw notifier with spinlock protection instead of atomic notifiers,
>   since some power-off handlers need to have interrupts enabled.
> - Renamed API functions from _poweroff to _power_off.
> - Added various Acks.
> - Build tested all configurations for arm, powerpc, and mips architecture=
s.
> - Fixed two compile errors in mips patch.
> - Replaced dev_err and pr_err with dev_warn and pr_warn if an error is not
>   fatal.
> - Provide managed resources API and use where appropriate.
> - Provide and use definitions for standard priorities.
> - Added patches to convert newly introduced power-off handlers.
> - Various minor changes.
>=20
> Important changes since RFC:
> - Move API to new file kernel/power/power_off_handler.c.
> - Move pm_power_off pointer to kernel/power/power_off_handler.c. Call
>   pm_power_off from do_kernel_power_off, and only call do_kernel_power_off
>   from architecture code instead of calling both pm_power_off and
>   do_kernel_power_off.
> - Provide additional API function register_power_off_handler_simple
>   to simplify conversion of architecture code.
> - Provide additional API function have_kernel_power_off to check if
>   a power-off handler was installed.
> - Convert all drivers and architecture code to use the new API.
> - Remove pm_power_off as last patch of the series.
>=20
> Cc: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
> Cc: Alexander Graf <agraf@suse.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> cc: Heiko Stuebner <heiko@sntech.de>
> Cc: Lee Jones <lee.jones@linaro.org>
> Cc: Len Brown <len.brown@intel.com>
> Cc: Pavel Machek <pavel@ucw.cz>
> Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
> Cc: Romain Perier <romain.perier@gmail.com>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
balbi

--9wW3yB/H9ZmnRBtb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUV8KHAAoJEIaOsuA1yqREOhcQAIWQZkqUnH0xm+6v2pCNnx5s
+SqgR9S1WrZfHhT+SBVKsEftNUa5XO99byCEs07kKvWxLQEiyIFU3izNdT3BIkbM
ny5eK6rAuj/uQm5dC3iM/IU12iu+UB7mGHEkq9Yp2H7e4uQ9s6RKcnd00JOEnZCe
QwRDeJ3CCIQRX6mC0Gu3XXMNIYsjxQW3zg1Bfrd4onwK0rH7fpy6lBOHbYQKU0at
1YPrd3s7XqcL5rf5xMQ26HBJywHBtRX7Tacg75phE7FMJyvsA2Dx0DXQ+qf1Szkj
B0DUogGzQZsuAuFQyEJfy6LhBFrqCudjsOLga0X0LczKplTXxOxyGX3xRgYFXuF9
gVLMcHlEeuA+up3ydqSxL0YqiozFIOG+uSlrY496UFWrOvikXtX9I3WQWGeumO5O
DDU4/tOK3QF258Bxf/Fsan6sE+E5b4PL5SDpWH9QlqObI5gU4q/Jt7g6rvmj1f3k
YKhy3dApJZu9Y+Chv2qAtwOp5Aztxtvrh/Hld8wKckaCCVah6DFUKIS+8Oq8cZ+T
m8YkvEbL9aRqTOx41ZLcYavCS9MDjq9HyYyJsu9cJxs7lo469dafC0ikRjS8S+li
+7ejifdzrSRWzKitcyCz0TGhCytw/PRIzz4J2HXaDtZAPJ7ZZ1ysbiAhTpfFB750
UaDs+2q4VUlzfwes8dg5
=E7Na
-----END PGP SIGNATURE-----

--9wW3yB/H9ZmnRBtb--
