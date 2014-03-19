Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213AbaCSGmW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 02:42:22 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:38395 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755912AbaCSGmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 02:42:19 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Andreas Dilger <adilger@dilger.ca>, NeilBrown <neilb@suse.de>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: For review: open_by_name_at(2) man page [v2]
Date: Wed, 19 Mar 2014 02:42:25 -0400
Message-ID: <4037316.YIp1ssalrz@vapier>
Organization: wh0rd.org
User-Agent: KMail/4.12.3 (Linux/3.13.0; KDE/4.12.3; x86_64; ; )
In-Reply-To: <53284233.3050800@gmail.com>
References: <53271B69.3000305@gmail.com> <53284233.3050800@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1515150.DgHbF18MxP"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart1515150.DgHbF18MxP
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

On Tue 18 Mar 2014 13:55:15 Michael Kerrisk wrote:
> The
> .I flags
> argument is a bit mask constructed by ORing together
> zero or more of the following value:
> .TP
> .B AT_EMPTY_PATH
> Allow
> .I pathname
> to be an empty string.
> See above.
> (which may have been obtained using the
> .BR open (2)
> .B O_PATH
> flag).
> .TP
> .B AT_SYMLINK_FOLLOW
> By default,
> .BR name_to_handle_at ()
> does not dereference
> .I pathname
> if it is a symbolic link.
> The flag
> .B AT_SYMLINK_FOLLOW
> can be specified in
> .I flags
> to cause
> .I pathname
> to be dereferenced if it is a symbolic link.

this section is only talking about |flags|, and further this part is on=
ly=20
talking about AT_SYMLINK_FOLLOW.  so this last sentence sounds super=20=

redundant.

how about reversing the sentence order so that both are implicit like i=
s done=20
in the openat() page and the description of O_NOFOLLOW ?

> .B ENOTDIR
> The file descriptor supplied in
> .I dirfd
> does not refer to a directory,
> and it it is not the case that both

"it" is duplicated

> .SS Obtaining a persistent filesystem ID
> The mount IDs in
> .IR /proc/self/mountinfo
> can be reused as filesystems are unmounted and mounted.
> Therefore, the mount ID returned by
> .BR name_to_handle_at (3)

should be () and not (3)

side note: this seems like an easy error to script for ...

> $ \fBecho 'Kannst du bitte =FCberlegen?' > cecilia.txt\fP

aber, ich spreche kein Deutsch :(

do we have a standard about sticking to english ?  i wonder if people a=
re more=20
likely to be confused or to appreciate it ...

> #define errExit(msg)    do { perror(msg); exit(EXIT_FAILURE); \\
>                         } while (0)

i wonder if err.h makes sense now that this is a man page for completel=
y=20
linux-specific syscalls :).  and you use _GNU_SOURCE.

> int
> main(int argc, char *argv[])
> {
>     struct file_handle *fhp;
>     int mount_id, fhsize, s;
>=20
>     if (argc < 2 || strcmp(argv[1], "\-\-help") =3D=3D 0) {

argc !=3D 2 ?

>     /* Allocate file_handle structure */
>=20
>     fhsize =3D sizeof(struct file_handle *);

pretty sure this is wrong as sizeof() here returns the size of a pointe=
r, not=20
the size of the struct.  it's why i prefer the form:

=09fhsize =3D sizeof(*fhp);

less typing and harder to screw up by accident.

granted, the case below won't crash since the kernel only reads/writes=20=

sizeof(unsigned int) and i'm not aware of any system where that is larg=
er than=20
sizeof(void *), but it's still wrong :).

>     s =3D name_to_handle_at(AT_FDCWD, argv[1], fhp, &mount_id, 0);

another personal style: create dedicated variables for each arg you unp=
ack out=20
of argv[1].  it's generally OK when you only take one arg, but when you=
 get=20
more than one, you end up flipping back and forth between the usage try=
ing to=20
figure out what index 1 represents instead of focusing on what the code=
 is=20
doing.
=09const char *pathname =3D argv[1];

>     fhsize =3D sizeof(struct file_handle) + fhp\->handle_bytes;

fhsize +=3D fhp->handle_bytes ?

it's the same, but i think nicer ;)

>     /* Write mount ID, file handle size, and file handle to stdout,
>        for later reuse by t_open_by_handle_at.c */
>=20
>     if (write(STDOUT_FILENO, &mount_id, sizeof(int)) !=3D sizeof(int)=
 ||
>             write(STDOUT_FILENO, &fhsize, sizeof(int)) !=3D sizeof(in=
t) ||
>             write(STDOUT_FILENO, fhp, fhsize) !=3D fhsize) {

seems like a whole lot of code spew for a simple printf() ?  you'd have=
 to=20
adjust the other program to use scanf(), but seems like the end result =
would=20
be nicer for users to experiment with ?

> static int
> open_mount_path_by_id(int mount_id)
> {
>     char *linep;
>     size_t lsize;
>     char mount_path[PATH_MAX];
>     int fmnt_id, fnd, nread;

could we buy a few more letters for these vars ?  i guess fmnt_id is th=
e=20
filesystem mount id, and fnd is "find".

also, getline() returns a ssize_t, not an int.

>     FILE *fp;
>=20
>     fp  =3D fopen("/proc/self/mountinfo", "r");

only one space before the =3D

i would encourage using the "e" flag whenever possible in the hopes tha=
t=20
someone might start using it in their own code base.

=09fp =3D fopen("/proc/self/mountinfo", "re");

>     for (fnd =3D 0; !fnd ; ) {

in my experience, seems like a while() loop makes more sense when you'r=
e=20
implementing a while() loop ...
=09fnd =3D 0;
=09while (!fnd) {

>         linep =3D NULL;
>         nread =3D getline(&linep, &lsize, fp);

this works, but it's unusual when using getline() as it kind of defeats=
 the=20
purpose of using the dyn allocation feature.

=09fnd =3D 0;
=09linep =3D NULL;
=09while (!fnd) {
=09=09nread =3D getline(&linep, &lsize, fp);
=09=09...
=09}
=09free(linep);

i don't think it complicates the code much more ?

>         if (nread =3D=3D \-1)
>             break;
>=20
> =09nread =3D sscanf(linep, "%d %*d %*s %*s %s", &fmnt_id, mount_path)=
;

indent is off here

>     return open(mount_path, O_RDONLY | O_DIRECTORY);

O_CLOEXEC for funsies ?

> int
> main(int argc, char *argv[])
> {
>     struct file_handle *fhp;
>     int mount_id, fd, mount_fd, fhsize;
>     ssize_t nread;
> #define BSIZE 1000
>     char buf[BSIZE];

why not sizeof(buf) and avoid the define ?

>     if (argc > 1 && strcmp(argv[1], "\-\-help") =3D=3D 0) {
>         fprintf(stderr, "Usage: %s [mount\-dir]]\\n",
>                 argv[0]);

how about also aborting when argc > 2 ?

>     if (argc > 1)
>         mount_fd =3D open(argv[1], O_RDONLY | O_DIRECTORY);

O_CLOEXEC ?

>     nread =3D read(fd, buf, BSIZE);
>     if (nread =3D=3D \-1)
>         errExit("read");
>     printf("Read %ld bytes\\n", (long) nread);

yikes, that's a bad habit to encourage.  read() returns a ssize_t, so p=
rint it=20
out using %zd.

> .SH SEE ALSO
> .BR blkid (1),
> .BR findfs (1),

i don't have a findfs(1).  i do have a findfs(8) ...
=2Dmike
--nextPart1515150.DgHbF18MxP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABAgAGBQJTKTxSAAoJEEFjO5/oN/WBk/8P/0KzwBcg9tkcPgVFpkENoVF6
jTuOJAzYbfxAZyPATodBruF8WTFoQ8tJ9Na9IuMc8YRqvdbr6FA+keaLFtDY89OV
vooxPEI/m2oHbxX/GB/uZLIOygz9yUVltR3PS+4aZ4NqwtWknNESB2lP+aO0JLkl
bGgSYiJiPo7FAC2MS24qqTvFcuiUEYKkuIMgjo8uKQhn1Huy/Kfhx5d9XPCF6wGV
Fbeldx/HoKgOmwijcXN8OpmFqlOdmhXJ6P7pPjv6pDA4QRkaVlsBmkY+wDmOesA3
svsmpXxd8nXQs861mYGViqm2t7qIAneOVFBB9YURCTv6IOuYW8wmsMvfj7sVnJT+
6E4n1Y2zltO5Tqrah6x0trH5fLJV/dR/tdt0h+kLiZVbgyOQHU2h+wFIyPTsJMEC
KpzDfJjCeohJqBrmGs49afysni/rrbRll80RbVMfeIXrWGT7dUI+2P1LaOL4/vak
epcynSMMHQTU5y174gj6a5+wgtJTJp8QF2+0gv1NVIGmrNZrauyiElNmNAw1zvgR
m4sMI46SuZwOqGR1jXWyLsjvQk2Mi+qHcO/5cIi14IFfsu90sVydWlU2yEJz4Xwm
ZWO+4YJqKzEOAiyZx5R3SQ3i28FvpTBI7gBMKtglesx0p7JmJpYowl9l9nHd5qRb
JLdSJmq5kALBhcJtsl8i
=+Aki
-----END PGP SIGNATURE-----

--nextPart1515150.DgHbF18MxP--

