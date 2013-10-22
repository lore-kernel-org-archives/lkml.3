Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355Ab3JVQug (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 12:50:36 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:41424 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755Ab3JVQuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 12:50:35 -0400
MIME-Version: 1.0
In-Reply-To: <20131022112117.GA2286@caracas.corpusers.net>
References: <1381411688-7128-1-git-send-email-oskar.andero@sonymobile.com>
	<CAPDyKFpMVFWO5=dpeqDuj7wyxvvxRgHtnEtKAKEFVeZd-FipBQ@mail.gmail.com>
	<20131022112117.GA2286@caracas.corpusers.net>
Date: Tue, 22 Oct 2013 18:50:33 +0200
Message-ID: <CAPDyKFrYvw0RjscTZbq+4DFoV_xiYAH=KcseC=T4bT5+RPUrGw@mail.gmail.com>
Subject: Re: [PATCH 1/1] MMC: Detect execution mode errors after r/w command
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Oskar Andero <oskar.andero@sonymobile.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>, Chris Ball <cjb@laptop.org>,
        "Svensson, Lars 1" <Lars1.Svensson@sonymobile.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 October 2013 13:21, Oskar Andero <oskar.andero@sonymobile.com> wrote:
> Hi Ulf,
>
> On 17:01 Wed 16 Oct     , Ulf Hansson wrote:
>> Hi Oskar / Lars,
>>
>> Sorry for the delayed response!
>>
>> On 10 October 2013 15:28, Oskar Andero <oskar.andero@sonymobile.com> wrote:
>> > From: Lars Svensson <lars1.svensson@sonymobile.com>
>> >
>> > Some error bits in the status field of R1/R1b response are only set
>> > by the device in response to the command following the failing
>> > command. The status is only read and checked after a r/w command if
>> > an error is detected during the initial command or the following data
>> > transfer. In some situations this causes errors passing undetected.
>> >
>> > The solution is to read the status and check for these errors after
>> > each r/w operation.
>>
>> I am a bit concerned about performance, especially when operating on
>> small packets.
>>
>> Previously we already sent a CMD13 after each write, thus this change
>> will have no effect on write performance. But for read, this will add
>> a CMD13 check after each request. Have you made any performance
>> measurement - how big is the impact? It is certainly interested to
>> know before proceeding.
>
> I just ran some iozone tests and I don't see any dramatic degrade in
> performance.
>
> This is before applying the patch:
>         Command line used: ./iozone_arm -az -i0 -i1 -s 50m -I
>         Output is in Kbytes/sec
>         Time Resolution = 0.000030 seconds.
>         Processor cache size set to 1024 Kbytes.
>         Processor cache line size set to 32 bytes.
>         File stride size set to 17 * record size.
>
>               KB  reclen   write rewrite    read    reread
>            51200       4     240     970     3294     3299
>            51200       8     457    1575     4648     4549
>            51200      16     862    2366     6487     6332
>            51200      32    1489    4181     8642     8661
>            51200      64    2509    5928    10852    10855
>            51200     128    3713    7856    12738    12742
>            51200     256    6167    9004    14404    14410
>            51200     512    8299   10448    15416    15414
>            51200    1024    9337    9458    16079    16082
>            51200    2048    9222    9729    16361    16365
>            51200    4096    8926   10526    16485    16477
>            51200    8192   10035   10179     8550    16455
>            51200   16384   10286   10726    16834    16835
>
> And this is after the patch has been applied:
>               KB  reclen   write rewrite    read    reread
>            51200       4     251     990     3280     3244
>            51200       8     460    1545     4460     4463
>            51200      16     878    2633     7023     7028
>            51200      32    1380    4394     9802     9832
>            51200      64    2457    6216    12314    12314
>            51200     128    3667    7894    14087    14088
>            51200     256    6422    5916    15085    15086
>            51200     512    5536   10994    12571    15659
>            51200    1024    9112    9499    16203    16205
>            51200    2048   10197   10502    16363    16368
>            51200    4096   10524   10238     8850    16309
>            51200    8192    9615   10456    16528    16529
>            51200   16384   10553   10428    16803    16803

Hi Oskar,

The numbers were not that impressing from the beginning, so that could
be why you don't see any impact.
What kind of card are you using, eMMC/SD? In what speed mode are the
card operating in?

Maybe I can help out doing additional testing here, not sure when I
will be able to do it though.

>
>> >
>> > Signed-off-by: Lars Svensson <lars1.svensson@sonymobile.com>
>> > Signed-off-by: Oskar Andero <oskar.andero@sonymobile.com>
>> > Cc: linux-mmc@vger.kernel.org
>> > ---
>> >  drivers/mmc/card/block.c | 105 +++++++++++++++++++++++++----------------------
>> >  1 file changed, 57 insertions(+), 48 deletions(-)
>> >
>> > diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
>> > index 1a3163f..05de087 100644
>> > --- a/drivers/mmc/card/block.c
>> > +++ b/drivers/mmc/card/block.c
>> > @@ -797,10 +797,9 @@ static int mmc_blk_cmd_error(struct request *req, const char *name, int error,
>> >   * Initial r/w and stop cmd error recovery.
>> >   * We don't know whether the card received the r/w cmd or not, so try to
>> >   * restore things back to a sane state.  Essentially, we do this as follows:
>> > - * - Obtain card status.  If the first attempt to obtain card status fails,
>> > - *   the status word will reflect the failed status cmd, not the failed
>> > - *   r/w cmd.  If we fail to obtain card status, it suggests we can no
>> > - *   longer communicate with the card.
>> > + * - Check card status. If the status_valid argument is false, the first attempt
>> > + *   to obtain card status failed and the status argument will not reflect the
>> > + *   failed r/w cmd.
>> >   * - Check the card state.  If the card received the cmd but there was a
>> >   *   transient problem with the response, it might still be in a data transfer
>> >   *   mode.  Try to send it a stop command.  If this fails, we can't recover.
>> > @@ -812,38 +811,15 @@ static int mmc_blk_cmd_error(struct request *req, const char *name, int error,
>> >   * Otherwise we don't understand what happened, so abort.
>> >   */
>> >  static int mmc_blk_cmd_recovery(struct mmc_card *card, struct request *req,
>> > -       struct mmc_blk_request *brq, int *ecc_err, int *gen_err)
>> > +       struct mmc_blk_request *brq, int *ecc_err, int *gen_err,
>> > +       bool status_valid, int status)
>> >  {
>> > -       bool prev_cmd_status_valid = true;
>> > -       u32 status, stop_status = 0;
>> > -       int err, retry;
>> > +       u32 stop_status = 0;
>> > +       int err;
>> >
>> >         if (mmc_card_removed(card))
>> >                 return ERR_NOMEDIUM;
>> >
>> > -       /*
>> > -        * Try to get card status which indicates both the card state
>> > -        * and why there was no response.  If the first attempt fails,
>> > -        * we can't be sure the returned status is for the r/w command.
>> > -        */
>> > -       for (retry = 2; retry >= 0; retry--) {
>> > -               err = get_card_status(card, &status, 0);
>> > -               if (!err)
>> > -                       break;
>> > -
>> > -               prev_cmd_status_valid = false;
>> > -               pr_err("%s: error %d sending status command, %sing\n",
>> > -                      req->rq_disk->disk_name, err, retry ? "retry" : "abort");
>> > -       }
>> > -
>> > -       /* We couldn't get a response from the card.  Give up. */
>> > -       if (err) {
>> > -               /* Check if the card is removed */
>> > -               if (mmc_detect_card_removed(card->host))
>> > -                       return ERR_NOMEDIUM;
>> > -               return ERR_ABORT;
>> > -       }
>> > -
>> >         /* Flag ECC errors */
>> >         if ((status & R1_CARD_ECC_FAILED) ||
>> >             (brq->stop.resp[0] & R1_CARD_ECC_FAILED) ||
>> > @@ -891,12 +867,12 @@ static int mmc_blk_cmd_recovery(struct mmc_card *card, struct request *req,
>> >         /* Check for set block count errors */
>> >         if (brq->sbc.error)
>> >                 return mmc_blk_cmd_error(req, "SET_BLOCK_COUNT", brq->sbc.error,
>> > -                               prev_cmd_status_valid, status);
>> > +                               status_valid, status);
>> >
>> >         /* Check for r/w command errors */
>> >         if (brq->cmd.error)
>> >                 return mmc_blk_cmd_error(req, "r/w cmd", brq->cmd.error,
>> > -                               prev_cmd_status_valid, status);
>> > +                               status_valid, status);
>> >
>> >         /* Data errors */
>> >         if (!brq->stop.error)
>> > @@ -1107,6 +1083,12 @@ static inline void mmc_apply_rel_rw(struct mmc_blk_request *brq,
>> >          R1_CC_ERROR |          /* Card controller error */             \
>> >          R1_ERROR)              /* General/unknown error */
>> >
>> > +#define EXE_ERRORS                                                     \
>> > +       (R1_OUT_OF_RANGE |      /* Command argument out of range */     \
>> > +        R1_ADDRESS_ERROR |     /* Misaligned address */                \
>> > +        R1_WP_VIOLATION |      /* Tried to write to protected block */ \
>> > +        R1_ERROR)              /* General/unknown error */
>> > +
>> >  static int mmc_blk_err_check(struct mmc_card *card,
>> >                              struct mmc_async_req *areq)
>> >  {
>> > @@ -1114,7 +1096,33 @@ static int mmc_blk_err_check(struct mmc_card *card,
>> >                                                     mmc_active);
>> >         struct mmc_blk_request *brq = &mq_mrq->brq;
>> >         struct request *req = mq_mrq->req;
>> > -       int ecc_err = 0, gen_err = 0;
>> > +       int retries, err, ecc_err = 0, gen_err = 0;
>> > +       u32 status = 0;
>> > +       bool status_valid = true;
>> > +
>> > +       /*
>> > +        * Try to get card status which indicates the card state after
>> > +        * command execution. If the first attempt fails, we can't be
>> > +        * sure the returned status is for the r/w command.
>> > +        */
>> > +       for (retries = 2; retries >= 0; retries--) {
>> > +               err = get_card_status(card, &status, 0);
>> > +               if (!err)
>> > +                       break;
>> > +
>> > +               status_valid = false;
>> > +               pr_err("%s: error %d sending status command, %sing\n",
>> > +                      req->rq_disk->disk_name, err,
>> > +                      retries ? "retry" : "abort");
>> > +       }
>>
>> Do we have to issue a CMD13 (get_card_status), even if we are using
>> the open-ended transmission sequence? In other words, could we make
>> use of the response from CMD12 (stop transmission) instead?
>
> That's probably a good idea. Do you know of a way to check if CMD12 has been
> sent or not?

Have a look for "mmc_host_cmd23", which gets translated into
"MMC_BLK_CMD23" for the mmc block layer. This will give you some hints
of were to look.

Kind regards
Ulf Hansson

>
> Thanks,
>  Oskar
