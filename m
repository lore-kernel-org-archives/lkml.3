Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629Ab3JWP6g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 11:58:36 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:46368 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480Ab3JWP6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 11:58:34 -0400
MIME-Version: 1.0
In-Reply-To: <87r4bcdok1.fsf@redhat.com>
References: <87r4bcdok1.fsf@redhat.com>
Date: Wed, 23 Oct 2013 17:58:33 +0200
Message-ID: <CAFLxGvxT1S3km=LordqFGbAb_pWc0cf3oE2ciS9uY4BBJJ231A@mail.gmail.com>
Subject: Re: [PATCH] pstore: avoid incorrectly mark entry as duplicate
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Madper Xie <cxie@redhat.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, Anton Vorontsov <anton@enomsg.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Lenny Szubowicz <lszubowi@redhat.com>,
        =?UTF-8?B?5oiQ6aqPIOiwog==?= <bbboson@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 4:55 PM, Madper Xie <cxie@redhat.com> wrote:
> pstore try to find duplicate entries by check both ID, type and psi.
> They are not really enough for efi backend. dumped vars always have
> the same type, psi and ID. like follows:
> dump-type0-9-1-1382511508-C-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
> dump-type0-9-1-1382515661-C-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
>
> The "duplicate" entries won't appear in pstorefs. And a complain will be
> print -- pstore: failed to load 76 record(s) from 'efi'
> So I add one more check: timespec.
>
> Signed-off-by: Madper Xie <cxie@redhat.com>
> ---
>  fs/pstore/inode.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
> index 1282384..f70f1e5 100644
> --- a/fs/pstore/inode.c
> +++ b/fs/pstore/inode.c
> @@ -47,6 +47,7 @@ static LIST_HEAD(allpstore);
>  struct pstore_private {
>         struct list_head list;
>         struct pstore_info *psi;
> +       struct timespec time;
>         enum pstore_type_id type;
>         u64     id;
>         int     count;
> @@ -290,7 +291,8 @@ int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id, int count,
>         list_for_each_entry(pos, &allpstore, list) {
>                 if (pos->type == type &&
>                     pos->id == id &&
> -                   pos->psi == psi) {
> +                   pos->psi == psi &&
> +                   !timespec_compare(&pos->time, &time)) {
>                         rc = -EEXIST;
>                         break;
>                 }
> @@ -312,6 +314,7 @@ int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id, int count,
>         private->id = id;
>         private->count = count;
>         private->psi = psi;
> +       memcpy(&private->time, &time, sizeof(struct timespec));
>
>         switch (type) {
>         case PSTORE_TYPE_DMESG:


As discussed on IRC, why don't you compare the variable names?

-- 
Thanks,
//richard
