Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170Ab3BEROT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 12:14:19 -0500
Received: from nm18-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.23]:44181
	"EHLO nm18-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755866Ab3BEROP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 12:14:15 -0500
X-Yahoo-Newman-Id: 4289.94352.bm@smtp107.biz.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: TyZIJ5oVM1kzOt299Rm7nKaR95uAQYQblN9t4M4Sy0MdVFX
 9ArE12TcsTSiWBXyU7tOUnZ9C2zuT1c1cDI_RlIvEzMuGfuDtQ2jqOW3FwN1
 rzpjQBQfs5q2hZk73P.XpA_vGnWNSc0lbRaxqYLM2oW6koAwla92OD2WZZ5r
 hemVM584qPw2zPkBJ9sow2tVPj4nBtgiKNGK.AP333VuOBaiA8tgSnifgrKI
 hPMYrcb4myi6Mv3eshS2.I7xJuLjAT_exBXPjwur0mo6UXwumgaHQlJcJ0Md
 alVb13tjkuio.P.JnY48UDb7VpsP152EfyfHqA4MPfahdS_rm7KATw.Ap69q
 .eAERdDT.8CmNKj1sRZM4aDxaGteOhq6nQgJUUOJU0IAMuy4pmGds4tmRkI5
 n0jjwv0Trpg5whnU64rSBTDXF4pC3L9fqHetKW_l_pZxFv6nSeAWIDgH.x.X
 0KthGy26GcKvo3QjxBVfHMx8pBn5PamQp7_jLWP3WhBUpYzU9G2ih66GHDzO
 GeyAcBAl2J9SjYtgO.g3b64wjQnUNH4pluiZ4F0sgDTjqUXOTgO7KiWA-
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <51113DE5.10008@schaufler-ca.com>
Date: Tue, 05 Feb 2013 09:14:13 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jeff Mahoney <jeffm@suse.com>
CC: Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, Dave Kleikamp <shaggy@kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [RFC] setxattr bugs
References: <20130203043046.GR4503@ZenIV.linux.org.uk> <51106AF1.4030804@suse.com>
In-Reply-To: <51106AF1.4030804@suse.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/4/2013 6:14 PM, Jeff Mahoney wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 2/2/13 11:30 PM, Al Viro wrote:
>> * JFS, since 2005: setxattr(name, "system.posix_acl_access", NULL,
>> 0, 0) succeeds, creating an empty EA with "system.posix_acl_access"
>> as name. Validity checks should apply _after_ if (value == NULL) {
>> /* empty EA, do not remove */ value = ""; value_len = 0; } and not
>> before it. * reiserfs, since 2009: setxattr(name, attr_name, NULL,
>> 0, 0) is treated as removexattr(name, attr_name), not as emptying
>> given xattr.
>>
>> The question is, does either of those cross into "established 
>> weirdness in ABI" or are they still at the "bugs to be fixed"
>> stage?
> Since the behavior changed once already in 2009 I'd call it a bug.
> That code was in the SLES kernel for a while before then and I still
> haven't seen a bug report on it.
>
> - -Jeff
>
>> FWIW, I'm seriously tempted to stop passing NULL as the third
>> argument of ->setxattr(), essentially taking all those if (!value)
>> value = ""; pieces from individual ->setxattr() instances to
>> __vfs_setxattr_noperm() (all other callers of ->setxattr() never 
>> pass NULL data or 0 size, so it's irrelevant for them).  Would fix 
>> both jfs and reiserfs weirdness....
>>
>> Objections?

None from me. I know of no one using either of those filesystems
in ways I care about. There's a chance the SELinux crowd may care,
so I'm adding the LSM list. We're the primary consumer of xattrs.

>
> - -- 
> Jeff Mahoney
> SUSE Labs
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG/MacGPG2 v2.0.18 (Darwin)
> Comment: GPGTools - http://gpgtools.org
>
> iQIcBAEBAgAGBQJREGrwAAoJEB57S2MheeWyHvMP/3kpy3Y4U0KNavnPaeL12LXe
> RC6vIb/dPkoSemFiZ5om26aT70M7MdXJY2ZPCwgtlNpKV6aT0NFchtwiWos2lLLN
> XndvFZ4M/kQLd9yDEmlcTDZn7p4fhU2Tn7FYrhPLRmOO3zP6fnUxLozSebOnGTO/
> xEwV7Qtx7D4Au37khFW/hJvsAJE2Q3NrLgueIJLiTmFvSiOourZNmriNcB73MUeb
> vYx5gc/bJexS2oFWeQqD6WiL8UQXg4XEKRk4inNVrJWpLV365w45Kpf2zBlvCQwQ
> W8mdHcHoityOcQJtiXvnVDurUNpFwsthrhVquVgIopovlcvOjNtcpffH8YI9khP/
> yol7+57ZDuVx2TY5DrEOa+TOTUrg5ghqagSSmOVDsOVeMngpdFNs8351QcX0IWBn
> Xt8/eq46g/R7EHI3I1eYJHlMIie0hP1GDc66OP94hcKEWaHbPeKwkSTOlqYH++4h
> ncSJcxHXWLUTGuV4b61whYTlJ2vBWwEvIteVaQmmXKaOTr41lajZBCWZDeUlzna8
> XyJHE5FrcKDLzTNP1R7UNEj863fN0OUma1AKaT/6jNYMqFXOk39emTgZL5QfxP9X
> uLWG1OVDf87uw5nYOKubNQiORpxl8iSIsQWvZeF9SvvmFA/JzpgZgtLlNqYa78Yv
> oEq501m9BSEWVSGKxHcu
> =G2cU
> -----END PGP SIGNATURE-----
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

