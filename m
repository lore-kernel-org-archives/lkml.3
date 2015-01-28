Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219AbbA2B0r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:26:47 -0500
Received: from mail-vc0-f172.google.com ([209.85.220.172]:48070 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755182AbbA2B0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:26:45 -0500
MIME-Version: 1.0
In-Reply-To: <1422439995-25745-1-git-send-email-david.oberhollenzer@sigma-star.at>
References: <1422439995-25745-1-git-send-email-david.oberhollenzer@sigma-star.at>
Date: Thu, 29 Jan 2015 00:43:57 +0100
Message-ID: <CAFLxGvy6bnPnzZyGXiAN8Jq54E7CDpF5CmvLzkAuuMn8jdUbmQ@mail.gmail.com>
Subject: Re: [PATCH] UBI: power cut emulation for testing
From: Richard Weinberger <richard.weinberger@gmail.com>
To: david.oberhollenzer@sigma-star.at
Cc: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 11:13 AM,  <david.oberhollenzer@sigma-star.at> wrote:
> From: David Oberhollenzer <david.oberhollenzer@sigma-star.at>
>
> Emulate random power cuts by switching device to ro after a number of
> writes to allow simple power cut testing with nand-sim.
>
> Maximum and minimum number of successful writes before power cut and
> what kind of writes (EC header, VID header or none) to interrupt
> configurable via debugfs.
>
> Signed-off-by: David Oberhollenzer <david.oberhollenzer@sigma-star.at>
> ---
>  drivers/mtd/ubi/debug.c | 93 +++++++++++++++++++++++++++++++++++++++++++++++--
>  drivers/mtd/ubi/debug.h |  2 ++
>  drivers/mtd/ubi/io.c    |  6 ++++
>  drivers/mtd/ubi/ubi.h   | 25 +++++++++++++
>  4 files changed, 124 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/mtd/ubi/debug.c b/drivers/mtd/ubi/debug.c
> index 7335c9f..ad164cc 100644
> --- a/drivers/mtd/ubi/debug.c
> +++ b/drivers/mtd/ubi/debug.c
> @@ -263,7 +263,7 @@ static ssize_t dfs_file_read(struct file *file, char __user *user_buf,
>         struct dentry *dent = file->f_path.dentry;
>         struct ubi_device *ubi;
>         struct ubi_debug_info *d;
> -       char buf[3];
> +       char buf[8];
>         int val;
>
>         ubi = ubi_get_device(ubi_num);
> @@ -281,6 +281,22 @@ static ssize_t dfs_file_read(struct file *file, char __user *user_buf,
>                 val = d->emulate_bitflips;
>         else if (dent == d->dfs_emulate_io_failures)
>                 val = d->emulate_io_failures;
> +       else if (dent == d->dfs_emulate_power_cut) {
> +               snprintf(buf, sizeof(buf), "%u\n", d->emulate_power_cut);
> +               count = simple_read_from_buffer(user_buf, count, ppos,
> +                                               buf, strlen(buf));
> +               goto out;
> +       } else if (dent == d->dfs_power_cut_min) {
> +               snprintf(buf, sizeof(buf), "%u\n", d->power_cut_min);
> +               count = simple_read_from_buffer(user_buf, count, ppos,
> +                                               buf, strlen(buf));
> +               goto out;
> +       } else if (dent == d->dfs_power_cut_max) {
> +               snprintf(buf, sizeof(buf), "%u\n", d->power_cut_max);
> +               count = simple_read_from_buffer(user_buf, count, ppos,
> +                                               buf, strlen(buf));
> +               goto out;
> +       }
>         else {
>                 count = -EINVAL;
>                 goto out;
> @@ -309,7 +325,7 @@ static ssize_t dfs_file_write(struct file *file, const char __user *user_buf,
>         struct ubi_device *ubi;
>         struct ubi_debug_info *d;
>         size_t buf_size;
> -       char buf[8];
> +       char buf[8]={0};

Spaces, please. checkpatch.pl will tell you. :)

>         int val;
>
>         ubi = ubi_get_device(ubi_num);
> @@ -323,6 +339,21 @@ static ssize_t dfs_file_write(struct file *file, const char __user *user_buf,
>                 goto out;
>         }
>
> +       if (dent == d->dfs_power_cut_min) {
> +               if (kstrtouint(buf, 0, &d->power_cut_min) != 0)
> +                       count = -EINVAL;
> +               goto out;
> +       } else if (dent == d->dfs_power_cut_max) {
> +               if (kstrtouint(buf, 0, &d->power_cut_max) != 0)
> +                       count = -EINVAL;
> +               goto out;
> +       } else if (dent == d->dfs_emulate_power_cut) {
> +               if (kstrtoint(buf, 0, &val) != 0)
> +                       count = -EINVAL;
> +               d->emulate_power_cut = val;
> +               goto out;
> +       }
> +
>         if (buf[0] == '1')
>                 val = 1;
>         else if (buf[0] == '0')
> @@ -427,6 +458,27 @@ int ubi_debugfs_init_dev(struct ubi_device *ubi)
>                 goto out_remove;
>         d->dfs_emulate_io_failures = dent;
>
> +       fname = "tst_emulate_power_cut";
> +       dent = debugfs_create_file(fname, S_IWUSR, d->dfs_dir, (void *)ubi_num,
> +                                  &dfs_fops);
> +       if (IS_ERR_OR_NULL(dent))
> +               goto out_remove;
> +       d->dfs_emulate_power_cut = dent;
> +
> +       fname = "tst_emulate_power_cut_min";
> +       dent = debugfs_create_file(fname, S_IWUSR, d->dfs_dir, (void *)ubi_num,
> +                                  &dfs_fops);
> +       if (IS_ERR_OR_NULL(dent))
> +               goto out_remove;
> +       d->dfs_power_cut_min = dent;
> +
> +       fname = "tst_emulate_power_cut_max";
> +       dent = debugfs_create_file(fname, S_IWUSR, d->dfs_dir, (void *)ubi_num,
> +                                  &dfs_fops);
> +       if (IS_ERR_OR_NULL(dent))
> +               goto out_remove;
> +       d->dfs_power_cut_max = dent;
> +
>         return 0;
>
>  out_remove:
> @@ -447,3 +499,40 @@ void ubi_debugfs_exit_dev(struct ubi_device *ubi)
>         if (IS_ENABLED(CONFIG_DEBUG_FS))
>                 debugfs_remove_recursive(ubi->dbg.dfs_dir);
>  }
> +
> +/**
> + * ubi_dbg_power_cut - emulate a power cut if it is time to do so
> + * @ubi: UBI device description object
> + * @caller: Flags set to indicate from where the function is being called
> + *
> + * Returns non-zero if a power cut was emulated, zero if not.
> + */
> +int ubi_dbg_power_cut(struct ubi_device *ubi, int caller)
> +{
> +       unsigned int range;
> +
> +       if (!ubi || ubi->dbg.power_cut_counter < 0)
>

No need to check for !ubi.

 +               return 0;
> +
> +       if ((ubi->dbg.emulate_power_cut & caller) == 0)
> +               return 0;
> +
> +       if (ubi->dbg.power_cut_counter == 0) {
> +               ubi->dbg.power_cut_counter = ubi->dbg.power_cut_min;
> +
> +               if (ubi->dbg.power_cut_max > ubi->dbg.power_cut_min) {
> +                       range = ubi->dbg.power_cut_max - ubi->dbg.power_cut_min;
> +                       ubi->dbg.power_cut_counter += prandom_u32() % range;
> +               }
> +               return 0;
> +       }
> +
> +       ubi->dbg.power_cut_counter--;
> +       if (ubi->dbg.power_cut_counter)
> +               return 0;
> +
> +       ubi->dbg.power_cut_counter = -1;
> +       ubi_msg(ubi,"XXXXXXXXXXXXXXXXX emulating a power cut XXXXXXXXXXXXXXXXXX");
> +       ubi_ro_mode(ubi);
> +       return 1;
> +}
> diff --git a/drivers/mtd/ubi/debug.h b/drivers/mtd/ubi/debug.h
> index cba89fc..d74b339 100644
> --- a/drivers/mtd/ubi/debug.h
> +++ b/drivers/mtd/ubi/debug.h
> @@ -127,4 +127,6 @@ static inline int ubi_dbg_chk_gen(const struct ubi_device *ubi)
>  {
>         return ubi->dbg.chk_gen;
>  }
> +
> +int ubi_dbg_power_cut(struct ubi_device *ubi, int caller);
>  #endif /* !__UBI_DEBUG_H__ */
> diff --git a/drivers/mtd/ubi/io.c b/drivers/mtd/ubi/io.c
> index 396aaa5..f77de8e 100644
> --- a/drivers/mtd/ubi/io.c
> +++ b/drivers/mtd/ubi/io.c
> @@ -859,6 +859,9 @@ int ubi_io_write_ec_hdr(struct ubi_device *ubi, int pnum,
>         if (err)
>                 return err;
>
> +       if (ubi_dbg_power_cut(ubi, POWER_CUT_EC_WRITE))
> +               return -EROFS;
> +
>         err = ubi_io_write(ubi, ec_hdr, pnum, 0, ubi->ec_hdr_alsize);
>         return err;
>  }
> @@ -1106,6 +1109,9 @@ int ubi_io_write_vid_hdr(struct ubi_device *ubi, int pnum,
>         if (err)
>                 return err;
>
> +       if (ubi_dbg_power_cut(ubi, POWER_CUT_VID_WRITE))
> +               return -EROFS;
> +
>         p = (char *)vid_hdr - ubi->vid_hdr_shift;
>         err = ubi_io_write(ubi, p, pnum, ubi->vid_hdr_aloffset,
>                            ubi->vid_hdr_alsize);
> diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
> index f80ffab..3886fdc 100644
> --- a/drivers/mtd/ubi/ubi.h
> +++ b/drivers/mtd/ubi/ubi.h
> @@ -151,6 +151,17 @@ enum {
>         UBI_BAD_FASTMAP,
>  };
>
> +/*
> + * Flags for emulate_power_cut in ubi_debug_info
> + *
> + * POWER_CUT_EC_WRITE: Emulate a power cut when writing an EC header
> + * POWER_CUT_VID_WRITE: Emulate a power cut when writing a VID header
> + */
> +enum {
> +       POWER_CUT_EC_WRITE = 0x01,
> +       POWER_CUT_VID_WRITE = 0x02,
> +};
> +
>  /**
>   * struct ubi_wl_entry - wear-leveling entry.
>   * @u.rb: link in the corresponding (free/used) RB-tree
> @@ -356,6 +367,10 @@ struct ubi_wl_entry;
>   * @disable_bgt: disable the background task for testing purposes
>   * @emulate_bitflips: emulate bit-flips for testing purposes
>   * @emulate_io_failures: emulate write/erase failures for testing purposes
> + * @emulate_power_cut: emulate power cut for testing purposes
> + * @power_cut_counter: count down for writes left until emulated power cut
> + * @power_cut_min: minimum number of writes before emulating a power cut
> + * @power_cut_max: maximum number of writes until emulating a power cut
>   * @dfs_dir_name: name of debugfs directory containing files of this UBI device
>   * @dfs_dir: direntry object of the UBI device debugfs directory
>   * @dfs_chk_gen: debugfs knob to enable UBI general extra checks
> @@ -363,6 +378,9 @@ struct ubi_wl_entry;
>   * @dfs_disable_bgt: debugfs knob to disable the background task
>   * @dfs_emulate_bitflips: debugfs knob to emulate bit-flips
>   * @dfs_emulate_io_failures: debugfs knob to emulate write/erase failures
> + * @dfs_emulate_power_cut: debugfs knob to emulate power cuts
> + * @dfs_power_cut_min: debugfs knob for minimum writes before power cut
> + * @dfs_power_cut_max: debugfs knob for maximum writes until power cut
>   */
>  struct ubi_debug_info {
>         unsigned int chk_gen:1;
> @@ -370,6 +388,10 @@ struct ubi_debug_info {
>         unsigned int disable_bgt:1;
>         unsigned int emulate_bitflips:1;
>         unsigned int emulate_io_failures:1;
> +       unsigned int emulate_power_cut:2;
> +       unsigned int power_cut_counter;
> +       unsigned int power_cut_min;
> +       unsigned int power_cut_max;
>         char dfs_dir_name[UBI_DFS_DIR_LEN + 1];
>         struct dentry *dfs_dir;
>         struct dentry *dfs_chk_gen;
> @@ -377,6 +399,9 @@ struct ubi_debug_info {
>         struct dentry *dfs_disable_bgt;
>         struct dentry *dfs_emulate_bitflips;
>         struct dentry *dfs_emulate_io_failures;
> +       struct dentry *dfs_emulate_power_cut;
> +       struct dentry *dfs_power_cut_min;
> +       struct dentry *dfs_power_cut_max;
>  };
>
>  /**
> --
> 2.2.2
>
>
> ______________________________________________________
> Linux MTD discussion mailing list
> http://lists.infradead.org/mailman/listinfo/linux-mtd/



-- 
Thanks,
//richard
