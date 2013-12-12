Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830Ab3LLOn3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 09:43:29 -0500
Received: from mail-bk0-f48.google.com ([209.85.214.48]:34964 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab3LLOn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 09:43:28 -0500
Date: Thu, 12 Dec 2013 15:42:12 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Cc: dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] dma-buf: Implement test module
Message-ID: <20131212144210.GA1527@ulmo.nvidia.com>
References: <1386858989-1487-1-git-send-email-treding@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mxv5cy4qt+RJ9ypb"
Content-Disposition: inline
In-Reply-To: <1386858989-1487-1-git-send-email-treding@nvidia.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mxv5cy4qt+RJ9ypb
Content-Type: multipart/mixed; boundary="wRRV7LY7NUeQGEoC"
Content-Disposition: inline


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 12, 2013 at 03:36:29PM +0100, Thierry Reding wrote:
> This is a simple test module that can be used to allocate, export and
> delete DMA-BUF objects. It can be used to test DMA-BUF sharing in
> systems that lack a real second driver.
>=20
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
>  drivers/base/Kconfig        |   4 +
>  drivers/base/Makefile       |   1 +
>  drivers/base/dma-buf-test.c | 308 ++++++++++++++++++++++++++++++++++++++=
++++++
>  3 files changed, 313 insertions(+)
>  create mode 100644 drivers/base/dma-buf-test.c

And attached is a small test program that I've been using to test this
new module. It can be built with:

	$ gcc -O2 -g -Wall -Werror -I/usr/include/libdrm -o dma-buf-test dma-buf-t=
est.c -ldrm

Thierry

--wRRV7LY7NUeQGEoC
Content-Type: text/x-c; charset=us-ascii
Content-Disposition: inline; filename="dma-buf-test.c"

/*
 * Copyright (C) 2013 NVIDIA Corporation
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License version 2 as published by
 * the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along with
 * this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include <errno.h>
#include <fcntl.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include <sys/ioctl.h>
#include <sys/mman.h>

#include <linux/ioctl.h>

#include <xf86drm.h>
#include <xf86drmMode.h>
#include <drm_fourcc.h>

struct dmabuf_create {
	__u32 flags;
	__u32 size;
};

#define DMABUF_IOCTL_BASE	'D'
#define DMABUF_IOCTL_CREATE	_IOWR(DMABUF_IOCTL_BASE, 0, struct dmabuf_create)
#define DMABUF_IOCTL_DELETE	_IOWR(DMABUF_IOCTL_BASE, 1, int)
#define DMABUF_IOCTL_EXPORT	_IOWR(DMABUF_IOCTL_BASE, 2, int)

#define DIV_ROUND_UP(n, d) (((n) + (d) - 1) / (d))

static const char default_dmabuf_device[] = "/dev/dmabuf";
static const char default_dri_card[] = "/dev/dri/card0";

struct screen {
	int fd;

	unsigned int width;
	unsigned int height;
	unsigned int pitch;
	unsigned int depth;
	unsigned int bpp;

	drmModeModeInfo mode;
	uint32_t fb, old_fb;
	uint32_t connector;
	uint32_t format;
	uint32_t handle;
	uint32_t crtc;
};

static int probe_connector(struct screen *screen, drmModeConnectorPtr connector)
{
	drmModeEncoderPtr encoder;
	drmModeCrtcPtr crtc;
	drmModeFBPtr fb;

	encoder = drmModeGetEncoder(screen->fd, connector->encoder_id);
	if (!encoder)
		return -ENODEV;

	crtc = drmModeGetCrtc(screen->fd, encoder->crtc_id);
	if (!crtc) {
		drmModeFreeEncoder(encoder);
		return -ENODEV;
	}

	screen->old_fb = crtc->buffer_id;

	fb = drmModeGetFB(screen->fd, crtc->buffer_id);
	if (!fb) {
		/* TODO: create new framebuffer */
		drmModeFreeEncoder(encoder);
		drmModeFreeCrtc(crtc);
		return -ENOSYS;
	}

	screen->connector = connector->connector_id;
	screen->old_fb = crtc->buffer_id;
	screen->crtc = encoder->crtc_id;
	/* TODO: check crtc->mode_valid */
	screen->mode = crtc->mode;

	screen->width = fb->width;
	screen->height = fb->height;
	screen->pitch = fb->pitch;
	screen->depth = fb->depth;
	screen->bpp = fb->bpp;

	drmModeFreeEncoder(encoder);
	drmModeFreeCrtc(crtc);
	drmModeFreeFB(fb);

	return 0;
}

static int screen_open(struct screen **screenp, int fd)
{
	drmModeConnectorPtr connector;
	struct screen *screen;
	bool found = false;
	drmModeResPtr res;
	unsigned int i;
	int err;

	if (!screenp || fd < 0)
		return -EINVAL;

	screen = calloc(1, sizeof(*screen));
	if (!screen)
		return -ENOMEM;

	screen->format = DRM_FORMAT_XRGB8888;
	screen->fd = fd;

	res = drmModeGetResources(fd);
	if (!res) {
		free(screen);
		return -ENOMEM;
	}

	for (i = 0; i < res->count_connectors; i++) {
		connector = drmModeGetConnector(fd, res->connectors[i]);
		if (!connector)
			continue;

		if (connector->connection != DRM_MODE_CONNECTED) {
			drmModeFreeConnector(connector);
			continue;
		}

		err = probe_connector(screen, connector);
		if (err < 0) {
			drmModeFreeConnector(connector);
			continue;
		}

		found = true;
		break;
	}

	drmModeFreeResources(res);

	if (!found) {
		free(screen);
		return -ENODEV;
	}

	*screenp = screen;

	return 0;
}

int screen_close(struct screen *screen)
{
	struct drm_gem_close args;
	int err;

	err = drmModeSetCrtc(screen->fd, screen->crtc, screen->old_fb, 0, 0,
			     &screen->connector, 1, &screen->mode);
	if (err < 0) {
		fprintf(stderr, "drmModeSetCrtc() failed: %m\n");
		return -errno;
	}

	err = drmModeRmFB(screen->fd, screen->fb);
	if (err < 0) {
		fprintf(stderr, "drmModeRmFB() failed: %m\n");
		return -errno;
	}

	memset(&args, 0, sizeof(args));
	args.handle = screen->handle;

	err = ioctl(screen->fd, DRM_IOCTL_GEM_CLOSE, &args);
	if (err < 0) {
		fprintf(stderr, "ioctl(DRM_IOCTL_GEM_CLOSE) failed: %m\n");
		return -errno;
	}

	return 0;
}

int screen_import(struct screen *screen, int buf)
{
	uint32_t handles[4], pitches[4], offsets[4];
	int err;

	err = drmPrimeFDToHandle(screen->fd, buf, &screen->handle);
	if (err < 0) {
		fprintf(stderr, "drmPrimeFDToHandle() failed: %m\n");
		return -errno;
	}

	printf("DRM handle: %x\n", screen->handle);

	handles[0] = screen->handle;
	pitches[0] = screen->pitch;
	offsets[0] = 0;

	err = drmModeAddFB2(screen->fd, screen->width, screen->height,
			    screen->format, handles, pitches, offsets,
			    &screen->fb, 0);
	if (err < 0) {
		fprintf(stderr, "drmModeAddFB() failed: %m\n");
		return -errno;
	}

	err = drmModeSetCrtc(screen->fd, screen->crtc, screen->fb, 0, 0,
			     &screen->connector, 1, &screen->mode);
	if (err < 0) {
		fprintf(stderr, "drmModeSetCrtc() failed: %m\n");
		return -errno;
	}

	return 0;
}

int dmabuf_create(int fd, size_t size, int flags)
{
	struct dmabuf_create args;

	memset(&args, 0, sizeof(args));
	args.flags = flags;
	args.size = size;

	return ioctl(fd, DMABUF_IOCTL_CREATE, &args);
}

int dmabuf_delete(int fd)
{
	return ioctl(fd, DMABUF_IOCTL_DELETE, 0);
}

int dmabuf_export(int fd, int flags)
{
	return ioctl(fd, DMABUF_IOCTL_EXPORT, flags);
}

void *dmabuf_mmap(int buf, off_t offset, size_t size)
{
	void *ptr;

	ptr = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED, buf, offset);
	if (ptr == MAP_FAILED)
		return NULL;

	return ptr;
}

void dmabuf_unmap(int buf, void *ptr, size_t size)
{
	munmap(ptr, size);
}

static void prepare_buffer(int buf, size_t size, struct screen *screen)
{
	void *ptr;

	/* TODO: handle other formats */
	if (screen->format != DRM_FORMAT_XRGB8888) {
		fprintf(stderr, "unsupported format: %x\n", screen->format);
		return;
	}

	ptr = dmabuf_mmap(buf, 0, size);
	if (ptr) {
		uint32_t colors[2] = { 0x00ff0000, 0x000000ff };
		unsigned int sx = 16;
		unsigned int sy = 16;
		uint32_t *fb = ptr;
		unsigned int i, j;

		for (j = 0; j < screen->height; j++) {
			unsigned int y = j / sy;

			for (i = 0; i < screen->width; i++) {
				unsigned int x = i / sx;

				*fb++ = colors[(x ^ y) & 1];
			}
		}

		dmabuf_unmap(buf, ptr, size);
	} else {
		fprintf(stderr, "dmabuf_mmap() failed: %m\n");
	}
}

int main(int argc, char *argv[])
{
	const char *dmabuf, *card;
	struct timeval timeout;
	struct screen *screen;
	int fd, err, buf, drm;
	size_t size;
	fd_set fds;

	if (argc < 2)
		dmabuf = default_dmabuf_device;
	else
		dmabuf = argv[1];

	if (argc < 3)
		card = default_dri_card;
	else
		card = argv[2];

	fd = open(dmabuf, O_RDWR);
	if (fd < 0) {
		fprintf(stderr, "open() failed: %m\n");
		return 1;
	}

	drm = open(card, O_RDWR);
	if (drm < 0) {
		fprintf(stderr, "open() failed: %m\n");
		return 1;
	}

	err = drmSetMaster(drm);
	if (err < 0) {
		fprintf(stderr, "drmSetMaster() failed: %m\n");
		return 1;
	}

	err = screen_open(&screen, drm);
	if (err < 0) {
		fprintf(stderr, "screen_open() failed: %s\n", strerror(-err));
		return 1;
	}

	size = screen->pitch * screen->height;

	err = dmabuf_create(fd, size, O_RDWR);
	if (err < 0) {
		fprintf(stderr, "dmabuf_create() failed: %m\n");
		return 1;
	}

	buf = dmabuf_export(fd, 0);
	if (buf < 0) {
		fprintf(stderr, "dmabuf_export() failed: %m\n");
		return 1;
	}

	printf("obtained DMA-BUF: %d\n", buf);

	prepare_buffer(buf, size, screen);

	err = screen_import(screen, buf);
	if (err < 0) {
		fprintf(stderr, "screen_import() failed: %s\n", strerror(-err));
		return 1;
	}

	FD_ZERO(&fds);
	FD_SET(STDIN_FILENO, &fds);

	memset(&timeout, 0, sizeof(timeout));
	timeout.tv_sec = 5;
	timeout.tv_usec = 0;

	err = select(STDIN_FILENO + 1, &fds, NULL, NULL, &timeout);
	if (err < 0) {
		fprintf(stderr, "select() failed: %m\n");
		return 1;
	}

	err = screen_close(screen);
	if (err < 0) {
		fprintf(stderr, "screen_close() failed: %s\n", strerror(-err));
		return 1;
	}

	err = dmabuf_delete(fd);
	if (err < 0) {
		fprintf(stderr, "dmabuf_delete() failed: %m\n");
		return 1;
	}

	close(buf);

	err = drmDropMaster(drm);
	if (err < 0) {
		fprintf(stderr, "drmDropMaster() failed: %m\n");
		return 1;
	}

	close(drm);
	close(fd);
	return 0;
}

--wRRV7LY7NUeQGEoC--

--mxv5cy4qt+RJ9ypb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSqctCAAoJEN0jrNd/PrOhL/QP/2MF3wbOakwTkxeALtro93m1
9Ok5HE4mre2WuMz8Irk9FjSNIH6Wx1hJQk/IF9lR0sJk50Q8zyOYm+rB1AkFYRM/
3FveRWfP1+kzVcz6EuLuW6005tEVM9CDPKLq44GctwFa/X0BrbS7iMbqxIDoH7Oi
VMhJA0PfvN0uvsoVz4yv2CXZ28BoUhYwkv9VcPRTUvDvREQFWJDfO31AqvN1NRfI
Bfi6YjPb5pJVRsJ+abJP4o/6Db/HtdHm+yRDOMzldmbQa3e9wuK8KOL6r9FoHSza
rQ71s6Z9Kdiodb3fvfrpUyyoysUn9WsvfhcrbQfZS41Uo5O+Y6KqFMeGJWET6231
TUg482qLJPbXoWNGrS+DsCyXW+83ELG+q/wRjMF7Ucp6+Ff20814LkML41+Me3es
xqiAsjbVdxG7OUqIo0Ci4T4CiVUOpUvqqr9ck6ZV7Ydaqn986p51drmRdSB8lMq3
fpuOetXeUVbfNoHAuuXWLYzTys5ZoW1frHzDXPQYjp4pFWUPbyYYKJHSG6gtrKw2
lEvBsFSzSPEKXZiV/f3j12BZO07O45BCqQ+gtXiXcYEe4ox6jVWDxdvjOvKHM8w7
Oh3VQDGu6LgwpiuyWST7rf9vNzjTrn8olckNtzq6gtnfXqsjjJ3UBEYlHXtTxP4p
pbWEKbeQYA76A4QAbLJV
=Y2lS
-----END PGP SIGNATURE-----

--mxv5cy4qt+RJ9ypb--
