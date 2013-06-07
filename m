Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831Ab3FGG27 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 02:28:59 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50336 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752479Ab3FGG24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 02:28:56 -0400
Message-ID: <1370586528.3693.1.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 049/184] x86/xen: dont assume %ds is usable in xen_iret for
From: Ben Hutchings <ben@decadent.org.uk>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jan Beulich <jbeulich@suse.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Fri, 07 Jun 2013 07:28:48 +0100
In-Reply-To: <20130604172132.342505782@1wt.eu>
References: <20130604172132.342505782@1wt.eu>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-cUUwl2BL+8j+e9xLgjuZ"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-cUUwl2BL+8j+e9xLgjuZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-06-04 at 19:22 +0200, Willy Tarreau wrote:
> 2.6.32-longterm review patch.  If anyone has any objections, please let m=
e know.
>=20
> ------------------
>  32-bit PVOPS.
>=20
> From: Jan Beulich <JBeulich@suse.com>

commit 13d2b4d11d69a92574a55bfd985cfb0ca77aebdc upstream.

> This fixes CVE-2013-0228 / XSA-42
>=20
> Drew Jones while working on CVE-2013-0190 found that that unprivileged gu=
est user
> in 32bit PV guest can use to crash the > guest with the panic like this:
>=20
> -------------
> general protection fault: 0000 [#1] SMP
> last sysfs file: /sys/devices/vbd-51712/block/xvda/dev
> Modules linked in: sunrpc ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4
> iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6
> xt_state nf_conntrack ip6table_filter ip6_tables ipv6 xen_netfront ext4
> mbcache jbd2 xen_blkfront dm_mirror dm_region_hash dm_log dm_mod [last
> unloaded: scsi_wait_scan]
>=20
> Pid: 1250, comm: r Not tainted 2.6.32-356.el6.i686 #1
> EIP: 0061:[<c0407462>] EFLAGS: 00010086 CPU: 0
> EIP is at xen_iret+0x12/0x2b
> EAX: eb8d0000 EBX: 00000001 ECX: 08049860 EDX: 00000010
> ESI: 00000000 EDI: 003d0f00 EBP: b77f8388 ESP: eb8d1fe0
>  DS: 0000 ES: 007b FS: 0000 GS: 00e0 SS: 0069
> Process r (pid: 1250, ti=3Deb8d0000 task=3Dc2953550 task.ti=3Deb8d0000)
> Stack:
>  00000000 0027f416 00000073 00000206 b77f8364 0000007b 00000000 00000000
> Call Trace:
> Code: c3 8b 44 24 18 81 4c 24 38 00 02 00 00 8d 64 24 30 e9 03 00 00 00
> 8d 76 00 f7 44 24 08 00 00 02 80 75 33 50 b8 00 e0 ff ff 21 e0 <8b> 40
> 10 8b 04 85 a0 f6 ab c0 8b 80 0c b0 b3 c0 f6 44 24 0d 02
> EIP: [<c0407462>] xen_iret+0x12/0x2b SS:ESP 0069:eb8d1fe0
> general protection fault: 0000 [#2]
> ---[ end trace ab0d29a492dcd330 ]---
> Kernel panic - not syncing: Fatal exception
> Pid: 1250, comm: r Tainted: G      D    ---------------
> 2.6.32-356.el6.i686 #1
> Call Trace:
>  [<c08476df>] ? panic+0x6e/0x122
>  [<c084b63c>] ? oops_end+0xbc/0xd0
>  [<c084b260>] ? do_general_protection+0x0/0x210
>  [<c084a9b7>] ? error_code+0x73/
> -------------
>=20
> Petr says: "
>  I've analysed the bug and I think that xen_iret() cannot cope with
>  mangled DS, in this case zeroed out (null selector/descriptor) by either
>  xen_failsafe_callback() or RESTORE_REGS because the corresponding LDT
>  entry was invalidated by the reproducer. "
>=20
> Jan took a look at the preliminary patch and came up a fix that solves
> this problem:
>=20
> "This code gets called after all registers other than those handled by
> IRET got already restored, hence a null selector in %ds or a non-null
> one that got loaded from a code or read-only data descriptor would
> cause a kernel mode fault (with the potential of crashing the kernel
> as a whole, if panic_on_oops is set)."
>=20
> The way to fix this is to realize that the we can only relay on the
> registers that IRET restores. The two that are guaranteed are the
> %cs and %ss as they are always fixed GDT selectors. Also they are
> inaccessible from user mode - so they cannot be altered. This is
> the approach taken in this patch.
>=20
> Another alternative option suggested by Jan would be to relay on
> the subtle realization that using the %ebp or %esp relative references us=
es
> the %ss segment.  In which case we could switch from using %eax to %ebp a=
nd
> would not need the %ss over-rides. That would also require one extra
> instruction to compensate for the one place where the register is used
> as scaled index. However Andrew pointed out that is too subtle and if
> further work was to be done in this code-path it could escape folks atten=
tion
> and lead to accidents.
>=20
> Reviewed-by: Petr Matousek <pmatouse@redhat.com>
> Reported-by: Petr Matousek <pmatouse@redhat.com>
> Reviewed-by: Andrew Cooper <andrew.cooper3@citrix.com>
> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> [dannf: backported to Debian's 2.6.32]
> Signed-off-by: Willy Tarreau <w@1wt.eu>
> ---
>  arch/x86/xen/xen-asm_32.S | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
>=20
> diff --git a/arch/x86/xen/xen-asm_32.S b/arch/x86/xen/xen-asm_32.S
> index 9a95a9c..d05bd11 100644
> --- a/arch/x86/xen/xen-asm_32.S
> +++ b/arch/x86/xen/xen-asm_32.S
> @@ -88,11 +88,11 @@ ENTRY(xen_iret)
>  	 */
>  #ifdef CONFIG_SMP
>  	GET_THREAD_INFO(%eax)
> -	movl TI_cpu(%eax), %eax
> -	movl __per_cpu_offset(,%eax,4), %eax
> -	mov per_cpu__xen_vcpu(%eax), %eax
> +	movl %ss:TI_cpu(%eax), %eax
> +	movl %ss:__per_cpu_offset(,%eax,4), %eax
> +	mov %ss:per_cpu__xen_vcpu(%eax), %eax
>  #else
> -	movl per_cpu__xen_vcpu, %eax
> +	movl %ss:per_cpu__xen_vcpu, %eax
>  #endif
> =20
>  	/* check IF state we're restoring */
> @@ -105,11 +105,11 @@ ENTRY(xen_iret)
>  	 * resuming the code, so we don't have to be worried about
>  	 * being preempted to another CPU.
>  	 */
> -	setz XEN_vcpu_info_mask(%eax)
> +	setz %ss:XEN_vcpu_info_mask(%eax)
>  xen_iret_start_crit:
> =20
>  	/* check for unmasked and pending */
> -	cmpw $0x0001, XEN_vcpu_info_pending(%eax)
> +	cmpw $0x0001, %ss:XEN_vcpu_info_pending(%eax)
> =20
>  	/*
>  	 * If there's something pending, mask events again so we can
> @@ -117,7 +117,7 @@ xen_iret_start_crit:
>  	 * touch XEN_vcpu_info_mask.
>  	 */
>  	jne 1f
> -	movb $1, XEN_vcpu_info_mask(%eax)
> +	movb $1, %ss:XEN_vcpu_info_mask(%eax)
> =20
>  1:	popl %eax
> =20

--=20
Ben Hutchings
Theory and practice are closer in theory than in practice.
                                - John Levine, moderator of comp.compilers

--=-cUUwl2BL+8j+e9xLgjuZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUbF9oOe/yOyVhhEJAQpi0Q//YUgt6QLa93ehE9FyLyDmx2QZezj8IYGh
godjExEZpYb/8WCohQQf0xLvYsW0LEi8KNUG9fTjTbC4vIxskGZ7/L9FOUQ+b9qb
QO0LJwoCT4KFjkTB5g0WkjxsStHc5vrfNZaxxaiyD1NcTq33MyTobvrKMAsm9jzf
H3Sqyq8vepNWKJHcLHmNPU7ijuPCfzL5yPTAOIkFmHKgDnAQjlaDBZw5kPbf9eff
3+vaJsuNIx761ehDlm5bphAKn5kzZX3Ro2WLIKah5lV70sgKIUwcIAp9uioHpSXh
DFThO/Vg09YL6WZQQ9nncsNa/JU8J1rcP3eoR3phlKvu1r1PLqzrelMdGTOmE9KF
+zenh8A3ovU+4h0qA3W4NkGa+TKiutTTNLhHa5EiOZ20Aj05GdZYeU0WLYtddtFE
D0HI2ru8ZXi9sv4ucsrUUfyixje7jhAlGpjiacZMKxf0UJhY5K/hrC4RKYGxvkoU
BuLZ1bydslxQo/sxRldSr7HKsffKU/3Ky1E/qZFNF/Cqob3791Gd7XWdxs21k1TA
Vpj45sGASwni45MZTyy0bGp6hB9+adVJwAWlTRGR0/qo8ZfD6QQtBtC7bJtl0wQP
67t5kTsF5JtIblD4RKp+5OlWYCJa+XTK2E9rhBcU82FHMgR5QqcgfK11yXQSktpp
odDSzjTxxO8=
=xX4l
-----END PGP SIGNATURE-----

--=-cUUwl2BL+8j+e9xLgjuZ--
