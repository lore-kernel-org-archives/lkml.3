Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213AbbANEKd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 23:10:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55961 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbbANEKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 23:10:32 -0500
Date: Tue, 13 Jan 2015 20:10:24 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Felipe Tonello <eu@felipetonello.com>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH] char: Added support for u-blox 6 i2c gps driver
Message-ID: <20150114041024.GA8056@kroah.com>
References: <1421198202-4042-1-git-send-email-eu@felipetonello.com>
 <20150114013350.GA11620@kroah.com>
 <CAGrhNMyEJgc5PB2y292PLyi52KO+zSxLPCjj3bANmkcsNDURwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGrhNMyEJgc5PB2y292PLyi52KO+zSxLPCjj3bANmkcsNDURwg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 06:07:27PM -0800, Felipe Tonello wrote:
> >> +static void ublox_gps_read_worker(struct work_struct *private);
> >> +
> >> +static DECLARE_DELAYED_WORK(ublox_gps_wq, ublox_gps_read_worker);
> >
> > Again, make device-specific.
> >
> >> +static void ublox_gps_read_worker(struct work_struct *private)
> >> +{
> >> +     s32 gps_buf_size, buf_size = 0;
> >> +     u8 *buf;
> >> +
> >> +     if (!ublox_gps_is_open)
> >> +             return;
> >
> > How can this happen?
> 
> If the tty device is closed and there is a scheduled workqueue, then
> this might happen.

What "prevents" this from happening on the very next line?

My point here, which I did a horrible job at getting across, is that
this isn't protecting or doing anything at all, as you have not done any
locking at all.

> >> +
> >> +     /* check if driver was removed */
> >> +     if (!ublox_gps_i2c_client)
> >> +             return;
> >
> > How can this happen?
> 
> If tty device is open and user removes the module (if it is a module)
> and there is a scheduled workqueue, then this might happen.

If this module is removed, how can this code be running?

Don't check for impossible things, it gives you false hope :)

> >> +static int ublox_gps_serial_open(struct tty_struct *tty, struct file *filp)
> >> +{
> >> +     if (ublox_gps_is_open)
> >> +             return -EBUSY;

Why do you care?

> >> +     ublox_gps_filp = filp;
> >> +     ublox_gps_tty_port = tty->port;
> >> +     ublox_gps_tty_port->low_latency = true; /* make sure we push data immediately */
> >> +     ublox_gps_is_open = true;
> >> +
> >> +     schedule_delayed_work(&ublox_gps_wq, 0);
> >> +
> >> +     return 0;
> >> +}
> >> +
> >> +static void ublox_gps_serial_close(struct tty_struct *tty, struct file *filp)
> >> +{
> >> +     if (!ublox_gps_is_open)
> >
> > How can this happen?
> 
> I am not sure. But it is better to check then having a unknown bug anyway.

No, don't check for things that are impossible to have happen, that
shows a lack of understanding for the code.

> >> +             return;
> >> +
> >> +     /* avoid stop when the denied (in open) file structure closes itself */
> >> +     if (ublox_gps_filp != filp)
> >> +             return;
> >
> > I don't understand, how can something "close itself"?
> 
> What happens is that this callback is called if a user tries to open
> two ttyS for the GPS. The second will fail, calling the close, thus
> calling this callback with different filp.

Why would the second call to open fail?  Why would you want it to fail?
Why do you care?

> So I need to check if the close was really called by the first ttyS user.

No, the tty layer should handle all of this for you, no need for you to
do anything here.

> >> +static int ublox_gps_serial_write(struct tty_struct *tty, const unsigned char *buf,
> >> +     int count)
> >> +{
> >> +     if (!ublox_gps_is_open)
> >> +             return 0;
> >> +
> >> +     /* check if driver was removed */
> >> +     if (!ublox_gps_i2c_client)
> >> +             return 0;
> >> +
> >> +     /* we don't write back to the GPS so just return same value here */
> >> +     return count;
> >> +}
> >
> > So write does nothing, why even have it at all?
> 
> Because for some reason the tty layer was calling it anyway.

How can the tty layer call a function that you don't define?

> >> +static int ublox_gps_write_room(struct tty_struct *tty)
> >> +{
> >> +     if (!ublox_gps_is_open)
> >> +             return 0;
> >> +
> >> +     /* check if driver was removed */
> >> +     if (!ublox_gps_i2c_client)
> >> +             return 0;
> >> +
> >> +     /* we don't write back to the GPS so just return some value here */
> >> +     return 1024;
> >
> > Why have this function at all if it does nothing?
> 
> Same as the write.

Same response as above :)

> >> +}
> >> +
> >> +static const struct tty_operations ublox_gps_serial_ops = {
> >> +     .open = ublox_gps_serial_open,
> >> +     .close = ublox_gps_serial_close,
> >> +     .write = ublox_gps_serial_write,
> >> +     .write_room = ublox_gps_write_room,
> >> +};
> >> +
> >> +static struct tty_driver *ublox_gps_tty_driver;
> >> +
> >> +static int ublox_gps_probe(struct i2c_client *client,
> >> +     const struct i2c_device_id *id)
> >> +{
> >> +     int result = 0;
> >> +
> >> +     ublox_gps_tty_driver = alloc_tty_driver(UBLOX_GPS_NUM);
> >> +     if (!ublox_gps_tty_driver)
> >> +             return -ENOMEM;
> >> +
> >> +     ublox_gps_tty_driver->owner = THIS_MODULE;
> >> +     ublox_gps_tty_driver->driver_name = "ublox_gps";
> >> +     ublox_gps_tty_driver->name = "ttyS";

Oh, I missed this, you can't just name your driver the same name as
other serial devices, with a different major number, that will cause
huge problems.

If you want to use the ttyS major/minor/name, then be a serial device,
not a tty device.

> >> +     ublox_gps_tty_driver->major = UBLOX_GPS_MAJOR;

Where did you get this major number from?

Why is this a tty device at all?  You aren't using any tty layer
specific things, are you doing this because userspace expects to open a
tty device?  Or some other reason?  If it expects this to be a tty
device, you need to implement a lot more here, otherwise userspace will
get confused.

thanks,

greg k-h
