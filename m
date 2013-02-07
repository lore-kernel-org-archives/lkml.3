Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751140Ab3BGF2w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 00:28:52 -0500
Received: from mail-ia0-f169.google.com ([209.85.210.169]:43040 "EHLO
	mail-ia0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab3BGF2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 00:28:49 -0500
Date: Wed, 06 Feb 2013 23:28:44 -0600
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH] Documentation: update top level 00-INDEX file with new
 additions
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>
In-Reply-To: <1359473640-4302-1-git-send-email-paul.gortmaker@windriver.com>
	(from paul.gortmaker@windriver.com on Tue Jan 29 09:34:00 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1360214924.12062.22@driftwood>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-yFKhJjBXatmTrXFcmq9X"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-yFKhJjBXatmTrXFcmq9X
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 01/29/2013 09:34:00 AM, Paul Gortmaker wrote:
> It seems there are about 80 new, but undocumented addtions at
> the top level Documentation directory.  This fixes up the top
> level 00-INDEX by adding new entries and deleting a couple orphans.
> Some subdirs could probably still use a check/cleanup too though.
>=20
> Cc: Rob Landley <rob@landley.net>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

I've got a script that makes html navigation pages from the 00-INDEX =20
files and another one that parses that to find dead links in both =20
directions. (Files with no 00-INDEX entry and 00-INDEX entries that =20
don't refer ot a file.)

I haven't run it in forever because the kernel.org guys took =20
everybody's accounts away, and they won't give me a new .ssh key =20
without a blood test or some such, and even if I did jump through the =20
hoops they made ssh go to a git wrapper you can't rsync through, so I =20
can't update kernel.org/doc/Documentation anymore. (Files attached =20
anyway.)

The patch looks good, but it also highlights the fact that this =20
directory needs a wholesale cleanup. Translations into languages the =20
developers don't speak and can't audit really don't belong in this =20
directory (they belong on the web somewhere), but Greg KH says =20
otherwise. The architecture stuff needs to be collated under an "arch" =20
directory the same way the source is. Zorro is still a serial driver at =20
the top level...

Sigh. I have buckets of things I want to do to this directory but no =20
longer have a kernel account. *shrug*

Acked-by: Rob Landley <rob@landley.net>

Can you send it through the trivial tree?

Rob=

--=-yFKhJjBXatmTrXFcmq9X
Content-Type: text/x-python; charset=us-ascii; name=doclinkcheck.py
Content-Disposition: attachment; filename=doclinkcheck.py
Content-Transfer-Encoding: quoted-printable

#!/usr/bin/python

import os,sys

# Get a list of files under the Documentation directory,
# filtering out instances of index.html

dirlist =3D []
for i in os.walk("Documentation"):
  for j in i[1]: dirlist.append("%s/%s/" % (i[0], j))
  for j in i[2]:
    if j!=3D"index.html": dirlist.append("%s/%s" % (i[0], j))
dirlist.sort()

# Function to parse a relative link and append it to a list.
taglist =3D []
def handletag(path, tag, data):
  tag =3D tag.split()
  if tag[0]=3D=3D"a":
    for i in tag:
      if i.startswith("href=3D"):
        i =3D i[5:]
        if i[0]=3D=3D'"' and i[-1]=3D=3D'"': i=3Di[1:-1]
        taglist.append("%s/%s" % (path, i))

# Find all the index.html files under Documentation, read each one,
# iterate through the html tags and call handletag() for each.

for dir in os.walk("Documentation"):
  if "index.html" in dir[2]:
    data =3D open("%s/index.html" % dir[0]).read()
    data =3D data.split("<")[1:]
    for i in data:
      i =3D i.split(">")
      handletag(dir[0], i[0], i[1])

# Display the links with no files, and the files nothing linked to.
print "404 errors:"
for i in filter(lambda a: a not in dirlist, taglist): print i
print "Unlinked documents:"
for i in filter(lambda a: a not in taglist, dirlist): print i
=

--=-yFKhJjBXatmTrXFcmq9X
Content-Type: text/x-python; charset=us-ascii; name=docdiridx.py
Content-Disposition: attachment; filename=docdiridx.py
Content-Transfer-Encoding: quoted-printable

#!/usr/bin/python

# Convert kernel Documentation/.../00-INDEX to index.html

import os,sys

for dir in os.walk("Documentation"):
  if not "00-INDEX" in dir[2]: continue

  # Read input

  lines =3D open("%s/00-INDEX" % dir[0]).read()

  lines =3D lines.split("00-INDEX",1)
  if len(lines)=3D=3D1:
    print "FAILED %s" % dir[0]
    continue

  # Open output, write header and <pre> section (if any)
  out =3D open("%s/index.html" % dir[0], "w")
  out.write("<html>\n<title>%s</title>\n<body>\n<ul>\n" % dir[0])
  if lines[0]: out.write("<pre>%s</pre>\n" % lines[0])
  lines =3D lines[1].split("\n")
  lines[0] =3D "00-INDEX"

  close =3D 0
  for idx in range(len(lines)):
    if not lines[idx]: continue
    if not lines[idx][0].isspace():
      if close: out.write('</li>\n')
      out.write('<li><a href=3D"%s">%s</a>' % (lines[idx].strip(), lines[id=
x].strip()))
      close =3D 1
    else: out.write(" %s" % lines[idx].strip())
  out.write("</li>\n</ul>\n</body>\n</html>\n")
=

--=-yFKhJjBXatmTrXFcmq9X--
