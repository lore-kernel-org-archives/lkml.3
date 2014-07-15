Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758808AbaGOLWA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 07:22:00 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:59186 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758039AbaGOLV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 07:21:56 -0400
MIME-Version: 1.0
In-Reply-To: <1405372789-24733-1-git-send-email-mcgrof@do-not-panic.com>
References: <1405372789-24733-1-git-send-email-mcgrof@do-not-panic.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Tue, 15 Jul 2014 16:51:35 +0530
Message-ID: <CABPxzYJLrjDujjxvuZyv_Wbx3E=NXAKnxROHohmP8MY32q8-vQ@mail.gmail.com>
Subject: Re: [PATCH] wireless: fixup genregdb.awk for remove of antenna gain
 from wireless-regd
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, linux-kernel@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        John Walker <john@x109.net>, John Linville <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, tiwai@suse.de,
        keescook@chromium.org, Felix Fietkau <nbd@openwrt.org>,
        "Luis R. Rodriguez" <mcgrof@suse.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 2:49 AM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> From: "Luis R. Rodriguez" <mcgrof@suse.com>
>
> Since "wireless-regdb: remove antenna gain" was merged in the
> wireless-regdb tree, the awk script parser has been incompatible
> with the 'official' regulatory database.  This fixes that up.
> Without this change the max EIRP is set to 0 making 802.11 devices
> useless.
>
> The fragile nature of the awk parser must be replaced, but ideas
> over how to do that in the most scalable way are being reviewed.
> In the meantime update the documentation for CFG80211_INTERNAL_REGDB
> so folks are aware of expectations for now.
>
> Reported-by: John Walker <john@x109.net>
> Reported-by: Krishna Chaitanya <chaitanya.mgit@gmail.com>
> Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
> ---
>
> !!! Note !!!
>
> This means older kernels that upgrade wireless-regdb and use
> CFG80211_INTERNAL_REGDB are bust too and they should then merge
> the latest updates to the awk script if they want to synch the
> wireless-regdb files with the kernel builds. The affected Linux
> distributions would be the users of CFG80211_INTERNAL_REGDB which
> should consists of OpenWrt which is reported to have this fixed
> already and mobile platforms.
>
> We are looking at a way to not have to deal with parsers all together
> at build time, for that discussion see:
>
> https://lkml.org/lkml/2014/7/14/706
>
>  net/wireless/Kconfig      |  6 ++++++
>  net/wireless/genregdb.awk | 35 ++++++++++++++++++++++-------------
>  2 files changed, 28 insertions(+), 13 deletions(-)
>
> diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
> index 405f3c4..29c8675 100644
> --- a/net/wireless/Kconfig
> +++ b/net/wireless/Kconfig
> @@ -162,6 +162,12 @@ config CFG80211_INTERNAL_REGDB
>           and includes code to query that database.  This is an alternative
>           to using CRDA for defining regulatory rules for the kernel.
>
> +         Using this option requires some parsing of the db.txt at build time,
> +         the parser will be upkept with the latest wireless-regdb updates but
> +         older wireless-regdb formats will be ignored. The parser may later
> +         be replaced to avoid issues with conflicts on versions of
> +         wireless-regdb.
> +
>           For details see:
>
>           http://wireless.kernel.org/en/developers/Regulatory
> diff --git a/net/wireless/genregdb.awk b/net/wireless/genregdb.awk
> index 40c37fc..baf2426 100644
> --- a/net/wireless/genregdb.awk
> +++ b/net/wireless/genregdb.awk
> @@ -51,32 +51,41 @@ function parse_country_head() {
>
>  function parse_reg_rule()
>  {
> +       flag_starts_at = 7
> +
>         start = $1
>         sub(/\(/, "", start)
>         end = $3
>         bw = $5
>         sub(/\),/, "", bw)
> -       gain = $6
> -       sub(/\(/, "", gain)
> -       sub(/,/, "", gain)
> -       power = $7
> -       sub(/\)/, "", power)
> -       sub(/,/, "", power)
> +       gain = 0
> +       power = $6
>         # power might be in mW...
> -       units = $8
> +       units = $7
> +       dfs_cac = 0
> +
> +       sub(/\(/, "", power)
> +       sub(/\),/, "", power)
> +       sub(/\),/, "", units)
>         sub(/\)/, "", units)
> -       sub(/,/, "", units)
> -       dfs_cac = $9
> +
>         if (units == "mW") {
> +               flag_starts_at = 8
>                 power = 10 * log(power)/log(10)
> +               if ($8 ~ /[[:digit:]]/) {
> +                       flag_starts_at = 9
> +                       dfs_cac = $8
> +               }
>         } else {
> -               dfs_cac = $8
> +               if ($7 ~ /[[:digit:]]/) {
> +                       flag_starts_at = 8
> +                       dfs_cac = $7
> +               }
>         }
> -       sub(/,/, "", dfs_cac)
>         sub(/\(/, "", dfs_cac)
> -       sub(/\)/, "", dfs_cac)
> +       sub(/\),/, "", dfs_cac)
>         flagstr = ""
> -       for (i=8; i<=NF; i++)
> +       for (i=flag_starts_at; i<=NF; i++)
>                 flagstr = flagstr $i
>         split(flagstr, flagarray, ",")
>         flags = ""


Acked-by:Krishna Chaitanya <chaitanya.mgit@gmail.com>
